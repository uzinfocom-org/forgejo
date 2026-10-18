{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OrPatterns #-}

-- | Receiving of webhooks which are sent by Forgejo.
module Forgejo.Webhook
  ( Delivery (..)
  , WebhookPayload (..)
  , WebhookAPI
  , parseWebhookPayload
  , webhookHandler
  , webhookHandlerWith
  ) where

import Control.Monad.Error.Class (MonadError)
import Crypto.Hash (Digest, SHA256 (..), digestFromByteString)
import Crypto.MAC.HMAC (HMAC (..), hmac)
import Control.Monad (unless)
import Data.Aeson (Value, parseJSON, eitherDecode)
import Data.Aeson.Types (parseEither)
import Data.ByteArray.Encoding qualified as BAE
import Data.ByteString qualified as BS
import Data.ByteString.Lazy qualified as BSL
import Data.ByteString.Lazy.Char8 qualified as BSLC
import Data.Text (Text)
import Data.Text.Encoding (encodeUtf8)
import Forgejo.Types.ActionRun (ActionRunPayload)
import Forgejo.Types.Event (ForgejoEvent (..))
import Forgejo.Types.EventType (ForgejoEventType)
import Forgejo.Types.IssueComment (IssueCommentPayload)
import Forgejo.Types.PullRequest (PullRequestPayload)
import Forgejo.Types.Push (PushPayload)
import Forgejo.Types.Release (ReleasePayload)
import Network.HTTP.Media ((//))
import Servant

-- | Custom content type used to capture both the raw lazy byte string and the decoded JSON value.
data RawAndJSON

instance Accept RawAndJSON where
  contentType _ = "application" // "json"

instance MimeUnrender RawAndJSON (BSL.ByteString, Value) where
  mimeUnrender _ rawBs = do
    val <- eitherDecode rawBs
    Right (rawBs, val)

-- | Name of the event, for example @pull_request@. It is lenient, so an unknown name doesn't fail the request.
type FGEvent = Header' '[Optional, Lenient] "x-forgejo-event" ForgejoEvent

-- | Type of the event, more precise than 'FGEvent' (for example @pull_request_sync@). Lenient too.
type FGEventTy = Header' '[Optional, Lenient] "x-forgejo-event-type" ForgejoEventType

-- | Unique id of a delivery. It is optional on purpose, a sender which is not Forgejo may not send it. A duplicated header is rejected.
type FGDelivery = Header' '[Optional, Strict] "x-forgejo-delivery" Text

-- | Header containing the HMAC-SHA256 signature sent by Forgejo (@X-Forgejo-Signature@).
type FGSignature = Header' '[Optional, Strict] "x-forgejo-signature" Text

-- | Payload of a delivery, parsed according to its event.
data WebhookPayload
  = -- | A push of commits.
    WPPush PushPayload
  | -- | Pull request events, and also reviews of it (approved, rejected, comment).
    WPPullRequest PullRequestPayload
  | -- | Comment on an issue or on a pull request.
    WPIssueComment IssueCommentPayload
  | -- | Result of a Forgejo Actions run.
    WPActionRun ActionRunPayload
  | -- | A release.
    WPRelease ReleasePayload

-- | What we know about a delivery besides its payload.
data Delivery = Delivery
  { deliveryId :: Maybe Text
  -- ^ Value of @X-Forgejo-Delivery@, 'Nothing' if the header was not sent.
  , deliveryEvent :: ForgejoEvent
  -- ^ Event from the header.
  , deliveryEventType :: Maybe ForgejoEventType
  -- ^ Event type from the header, 'Nothing' if it is missing or unknown.
  }

{- | Parse the body of a delivery according to its event.

  * 'Left': the body is malformed for this event
  * @'Right' 'Nothing'@: the event is known, but we don't handle it
  * @'Right' ('Just' payload)@: the parsed payload

  TODO: events like @issues@ are ignored for now, need to implement @IssuePayload@ for them.
-}
parseWebhookPayload :: ForgejoEvent -> Value -> Either String (Maybe WebhookPayload)
parseWebhookPayload Push v = Just . WPPush <$> parseEither parseJSON v
parseWebhookPayload (PullRequest; PullRequestApproved; PullRequestRejected; PullRequestComment) v =
  Just . WPPullRequest <$> parseEither parseJSON v
parseWebhookPayload IssueComment v = Just . WPIssueComment <$> parseEither parseJSON v
parseWebhookPayload ActionRunSuccess v = Just . WPActionRun <$> parseEither parseJSON v
parseWebhookPayload Release v = Just . WPRelease <$> parseEither parseJSON v
parseWebhookPayload _ _ = Right Nothing

-- | Route of the webhook receiver. It answers nothing, Forgejo only looks at the status code.
type WebhookAPI =
  FGEvent
  :> FGEventTy
  :> FGDelivery
  :> FGSignature
  :> ReqBody '[RawAndJSON] (BSL.ByteString, Value)
  :> Post '[JSON] ()

{- | Verifies a Forgejo HMAC-SHA256 signature against the request body.
   Returns 'True' if the signature matches the expected hash computed with the secret key.
-}
verifySignature :: BS.ByteString -> BS.ByteString -> BS.ByteString -> Bool
verifySignature key msg sigHex =
  case BAE.convertFromBase BAE.Base16 sigHex :: Either String BS.ByteString of
    Left _ -> False
    Right sig -> case digestFromByteString sig :: Maybe (Digest SHA256) of
      Nothing -> False
      Just d -> hmac key msg == HMAC d

{- | Handle a delivery and give the callback its 'Delivery' together with the parsed payload.

  * malformed body: answers 400
  * event which we don't handle: answers 200, the callback is not called
  * event header is missing or unknown: answers 200, the callback is not called
  * signature header is missing or invalid: answers 401
-}
webhookHandlerWith
  :: (MonadError ServerError m)
  => BS.ByteString
  -> (Delivery -> WebhookPayload -> m ())
  -> Maybe (Either Text ForgejoEvent)
  -> Maybe (Either Text ForgejoEventType)
  -> Maybe Text
  -> Maybe Text
  -> (BSL.ByteString, Value)
  -> m ()
webhookHandlerWith secret cb mEvent mEventType mDeliveryId mSig (rawBody, body) = do
  sig <- maybe (throwError signatureErr) pure mSig
  unless (verifySignature secret (BS.toStrict rawBody) (encodeUtf8 sig)) $
    throwError signatureErr

  case mEvent of
    Just (Right event) -> do
      payload <- case parseWebhookPayload event body of
        Left err -> throwError err400{errBody = BSLC.pack err}
        Right res -> pure res

      case payload of
        Just p -> cb delivery p
        Nothing -> pure ()
    _ -> pure ()
 where
  delivery =
    Delivery
      { deliveryId = mDeliveryId
      , deliveryEvent = maybe (error "unreachable") id (mEvent >>= either (const Nothing) Just) -- or handle cleanly
      , deliveryEventType = mEventType >>= either (const Nothing) Just
      }

-- | Error returned when the signature is missing or fails verification.
signatureErr :: ServerError
signatureErr = err401{errBody = BSLC.pack "Invalid or missing X-Forgejo-Signature"}

-- | Same as 'webhookHandlerWith' for callbacks which don't need the 'Delivery'.
webhookHandler
  :: (MonadError ServerError m)
  => BS.ByteString
  -> (WebhookPayload -> m ())
  -> Maybe (Either Text ForgejoEvent)
  -> Maybe (Either Text ForgejoEventType)
  -> Maybe Text
  -> Maybe Text
  -> (BSL.ByteString, Value)
  -> m ()
webhookHandler secret cb = webhookHandlerWith secret (const cb)
