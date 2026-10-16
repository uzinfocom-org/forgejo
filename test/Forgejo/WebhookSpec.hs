module Forgejo.WebhookSpec (spec) where

import Control.Monad.Except (ExceptT, runExceptT)
import Data.Aeson (Value (..), object)
import Data.Either (isLeft, isRight)
import Data.Text (Text)
import Forgejo.Types.Event (ForgejoEvent (..))
import Forgejo.Webhook (WebhookPayload, parseWebhookPayload, webhookHandler)
import Servant.Server (ServerError)
import Test.Hspec

type TestM = ExceptT ServerError IO

run :: TestM () -> IO (Either ServerError ())
run = runExceptT

-- Strip the payload so we get a type with Show/Eq for assertions.
result :: ForgejoEvent -> Value -> Either String ()
result event body = fmap (const ()) (parseWebhookPayload event body)

spec :: Spec
spec = do
  describe "parseWebhookPayload" $ do
    describe "unsupported events" $ do
      it "rejects Create"
        $ result Create Null `shouldBe` Left "unsupported event type"
      it "rejects Delete"
        $ result Delete Null `shouldBe` Left "unsupported event type"
      it "rejects Fork"
        $ result Fork Null `shouldBe` Left "unsupported event type"
      it "rejects Issues"
        $ result Issues Null `shouldBe` Left "unsupported event type"
      it "rejects Release"
        $ result Release Null `shouldBe` Left "unsupported event type"

    describe "supported events with invalid body" $ do
      it "returns a parse error for Push"
        $ result Push (object []) `shouldSatisfy` isLeft
      it "returns a parse error for IssueComment"
        $ result IssueComment (object []) `shouldSatisfy` isLeft
      it "returns a parse error for PullRequest"
        $ result PullRequest (object []) `shouldSatisfy` isLeft
      it "returns a parse error for ActionRunSuccess"
        $ result ActionRunSuccess (object []) `shouldSatisfy` isLeft

  describe "webhookHandler" $ do
    let hm :: WebhookPayload -> TestM ()
        hm _ = pure ()

    it "succeeds when event header is absent" $ do
      r <- run $ webhookHandler hm Nothing Nothing Null
      r `shouldSatisfy` isRight

    it "succeeds when event header failed to parse" $ do
      r <- run $ webhookHandler hm (Just (Left "data" :: Either Text ForgejoEvent)) Nothing Null
      r `shouldSatisfy` isRight

    it "fails with 400 when event is supported but body is malformed" $ do
      r <- run $ webhookHandler hm (Just (Right Push)) Nothing (object [])
      r `shouldSatisfy` isLeft
