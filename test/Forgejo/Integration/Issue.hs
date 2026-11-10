module Forgejo.Integration.Issue (spec) where

import Data.Text (Text)
import Forgejo (AppEnv, ForgejoError (..), User (..), createIssue, createRepository, runForgejo)
import Forgejo.Integration.Helpers (uniqueName, withCreatedRepo)
import Forgejo.Methods.Issue (createIssueComment)
import Forgejo.Types.Comment (Comment (..))
import Forgejo.Types.CreateIssueCommentOption (CreateIssueCommentApiOption (..), CreateIssueCommentOption (..))
import Forgejo.Types.CreateIssueOption (CreateIssueApiOption (..), CreateIssueOption (..))
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption (..))
import Forgejo.Types.Issue (Issue (..))
import Forgejo.Types.Repository (Repository (..))
import Test.Hspec

spec :: SpecWith AppEnv
spec = do
  describe "createIssue"
    $ aroundAllWith withIssue
    $ do
      it "creates an issue with the expected title" $ \(_, _, issue) ->
        issue.issueTitle `shouldBe` "Integration test issue"

      it "stores the given body" $ \(_, _, issue) ->
        issue.issueBody `shouldBe` "created by hspec"

  describe "createIssueComment"
    $ aroundAllWith withIssue
    $ do
      it "creates a comment on the issue" $ \(env, r, issue) -> do
        result <- runForgejo env . createIssueComment $ commentOpt r issue.issueNumber "integration test comment"
        case result of
          Left err -> expectationFailure $ show err
          Right c -> c.commentBody `shouldBe` "integration test comment"

      it "returns ErrValidation for an empty comment body" $ \(env, r, issue) -> do
        result <- runForgejo env . createIssueComment $ commentOpt r issue.issueNumber ""
        result `shouldSatisfy` \case
          Left ErrValidation{} -> True
          _ -> False

      it "returns ErrNotFound for a nonexistent issue index" $ \(env, r, _) -> do
        result <- runForgejo env . createIssueComment $ commentOpt r 999999 "ghost"
        result `shouldSatisfy` \case
          Left ErrNotFound{} -> True
          _ -> False
 where
  commentOpt :: Repository -> Int -> Text -> CreateIssueCommentOption
  commentOpt r index body =
    CreateIssueCommentOption
      r.repoOwner.userLogin
      r.repoName
      index
      $ CreateIssueCommentApiOption body

-- ---------------------------------------------------------------------------

{- | Create a throwaway repository with one issue in it for the whole group,
deleting the repository once every test in the group has run.
-}
withIssue :: ((AppEnv, Repository, Issue) -> IO ()) -> AppEnv -> IO ()
withIssue action env = do
  name <- uniqueName "hspec-issues"
  withCreatedRepo env (createRepository $ CreateRepositoryOption "issue integration tests" name False) $ \r -> do
    issue <- setupIssue env r
    action (env, r, issue)

setupIssue :: AppEnv -> Repository -> IO Issue
setupIssue env r = do
  let opt =
        CreateIssueOption r.repoOwner.userLogin r.repoName
          $ CreateIssueApiOption
            "Integration test issue"
            (Just "created by hspec")
            []
            Nothing
            Nothing
            Nothing
            Nothing
            Nothing
  result <- runForgejo env $ createIssue opt
  case result of
    Left err -> fail $ "setup failed: " <> show err
    Right issue -> pure issue
