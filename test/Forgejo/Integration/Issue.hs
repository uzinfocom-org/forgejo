module Forgejo.Integration.Issue (spec) where

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

      it "creates a comment on the issue" $ \(env, r, issue) -> do
        let opt =
              CreateIssueCommentOption
                r.repoOwner.userLogin
                r.repoName
                issue.issueNumber
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
        Left (ErrNotFound{}) -> True
        _ -> False

-- ---------------------------------------------------------------------------

{- | Create a throwaway repository with one issue in it for the whole group,
deleting the repository once every test in the group has run.
-}
withIssue :: ((AppEnv, Repository, Issue) -> IO ()) -> AppEnv -> IO ()
withIssue action env = do
  name <- uniqueName "hspec-issues"
  withCreatedRepo env (createRepository (CreateRepositoryOption "issue integration tests" name False)) $ \r -> do
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
  result <- runForgejo env (createIssue opt)
  case result of
    Left err -> fail ("setup failed: " <> show err)
    Right issue -> pure issue
