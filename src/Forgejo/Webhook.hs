module Forgejo.Webhook
  ( WebhookPayload (..)
  , WebhookAPI
  , parseWebhookPayload
  , webhookHandler
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

type FGEvent = Header' '[Optional, Lenient] "x-forgejo-event" ForgejoEvent
type FGEventTy = Header' '[Optional, Lenient] "x-forgejo-event-type" ForgejoEventType

data WebhookPayload
  = WPPush PushPayload
  | WPPullRequest PullRequestPayload
  | WPIssueComment IssueCommentPayload
  | WPActionRun ActionRunPayload
  | WPRelease ReleasePayload

parseWebhookPayload :: ForgejoEvent -> Value -> Either String WebhookPayload
parseWebhookPayload Push v = WPPush <$> parseEither parseJSON v
parseWebhookPayload PullRequest v = WPPullRequest <$> parseEither parseJSON v
parseWebhookPayload IssueComment v = WPIssueComment <$> parseEither parseJSON v
parseWebhookPayload ActionRunSuccess v = WPActionRun <$> parseEither parseJSON v
parseWebhookPayload Release v = WPRelease <$> parseEither parseJSON v
parseWebhookPayload _ _ = Left "unsupported event type"

type WebhookAPI =
  FGEvent :> FGEventTy :> ReqBody '[JSON] Value :> Post '[JSON] ()

webhookHandler
  :: (MonadError ServerError m)
  => (WebhookPayload -> m ())
  -> Maybe (Either Text ForgejoEvent)
  -> Maybe (Either Text ForgejoEventType)
  -> Value
  -> m ()
webhookHandler cb (Just (Right event)) _ body =
  case parseWebhookPayload event body of
    Left err -> throwError err400{errBody = BSLC.pack err}
    Right payload -> cb payload
webhookHandler _ _ _ _ = pure ()
