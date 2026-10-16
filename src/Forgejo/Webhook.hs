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
import Data.Aeson (Value, parseJSON)
import Data.Aeson.Types (parseEither)
import Data.ByteString.Lazy.Char8 qualified as BSLC
import Data.Text (Text)
import Forgejo.Types.ActionRun (ActionRunPayload)
import Forgejo.Types.Event (ForgejoEvent (..))
import Forgejo.Types.EventType (ForgejoEventType)
import Forgejo.Types.IssueComment (IssueCommentPayload)
import Forgejo.Types.PullRequest (PullRequestPayload)
import Forgejo.Types.Push (PushPayload)
import Forgejo.Types.Release (ReleasePayload)
import Servant

-- | Name of the event, for example @pull_request@. It is lenient, so an unknown name doesn't fail the request.
type FGEvent = Header' '[Optional, Lenient] "x-forgejo-event" ForgejoEvent

-- | Type of the event, more precise than 'FGEvent' (for example @pull_request_sync@). Lenient too.
type FGEventTy = Header' '[Optional, Lenient] "x-forgejo-event-type" ForgejoEventType

-- | Unique id of a delivery. It is optional on purpose, a sender which is not Forgejo may not send it. A duplicated header is rejected.
type FGDelivery = Header' '[Optional, Strict] "x-forgejo-delivery" Text

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
  FGEvent :> FGEventTy :> FGDelivery :> ReqBody '[JSON] Value :> Post '[JSON] ()

{- | Handle a delivery and give the callback its 'Delivery' together with the parsed payload.

  * malformed body: answers 400
  * event which we don't handle: answers 200, the callback is not called
  * event header is missing or unknown: answers 200, the callback is not called

  FIXME: the body is already parsed when we get it, so the signature of a delivery
  (@X-Forgejo-Signature@) can't be verified here. Need the raw body for it.
-}
webhookHandlerWith
  :: (MonadError ServerError m)
  => (Delivery -> WebhookPayload -> m ())
  -> Maybe (Either Text ForgejoEvent)
  -> Maybe (Either Text ForgejoEventType)
  -> Maybe Text
  -> Value
  -> m ()
webhookHandlerWith cb (Just (Right event)) mEventType mDeliveryId body =
  case parseWebhookPayload event body of
    Left err -> throwError err400{errBody = BSLC.pack err}
    Right Nothing -> pure ()
    Right (Just payload) -> cb delivery payload
 where
  delivery =
    Delivery
      { deliveryId = mDeliveryId
      , deliveryEvent = event
      , deliveryEventType = mEventType >>= either (const Nothing) Just
      }
webhookHandlerWith _ _ _ _ _ = pure ()

-- | Same as 'webhookHandlerWith' for callbacks which don't need the 'Delivery'.
webhookHandler
  :: (MonadError ServerError m)
  => (WebhookPayload -> m ())
  -> Maybe (Either Text ForgejoEvent)
  -> Maybe (Either Text ForgejoEventType)
  -> Maybe Text
  -> Value
  -> m ()
webhookHandler cb = webhookHandlerWith (const cb)
