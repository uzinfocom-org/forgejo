module Forgejo.Integration.Issue (spec) where

import Data.Text (Text)
import Forgejo (AppEnv, ForgejoError (..), createIssue, runForgejo)
import Forgejo.Methods.Issue (createIssueComment)
import Forgejo.Types.Comment (Comment (..))
import Forgejo.Types.CreateIssueCommentOption (CreateIssueCommentApiOption (..), CreateIssueCommentOption (..))
import Forgejo.Types.CreateIssueOption (CreateIssueApiOption (..), CreateIssueOption (..))
import Forgejo.Types.Issue (Issue (..))
import Test.Hspec

spec :: Text -> Text -> SpecWith AppEnv
spec owner repo = do
  describe "createIssue"
    $ beforeAllWith (\env -> (env,) <$> setupIssue env owner repo)
    $ do
      it "creates an issue with the expected title" $ \(_, issue) ->
        issue.issueTitle `shouldBe` "Integration test issue"

      it "creates a comment on the issue" $ \(env, issue) -> do
        let opt =
              CreateIssueCommentOption
                owner
                repo
                (issue.issueNumber)
                (CreateIssueCommentApiOption "integration test comment")
        result <- runForgejo env (createIssueComment opt)
        case result of
          Left err -> expectationFailure (show err)
          Right c -> c.commentBody `shouldBe` "integration test comment"

  describe "errors"
    $ it "returns ErrNotFound for a nonexistent owner/repo"
    $ \env -> do
      let opt =
            CreateIssueOption
              "owner-xyz-does-not-exist"
              "repo-xyz"
              (CreateIssueApiOption "t" Nothing [] Nothing Nothing Nothing Nothing Nothing)
      result <- runForgejo env (createIssue opt)
      result `shouldSatisfy` \case
        Left (ErrNotFound _ _ _) -> True
        _ -> False

-- ---------------------------------------------------------------------------

setupIssue :: AppEnv -> Text -> Text -> IO Issue
setupIssue env owner repo = do
  let opt =
        CreateIssueOption owner repo
          $ CreateIssueApiOption
            "Integration test issue"
            (Just "created by hspec")
            []
            Nothing
            Nothing
            Nothing
            Nothing
            Nothing
  result <- runForgejo env (createIssue opt)
  case result of
    Left err -> fail ("setup failed: " <> show err)
    Right issue -> pure issue
