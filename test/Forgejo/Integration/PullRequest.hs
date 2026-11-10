module Forgejo.Integration.PullRequest (spec) where

import Data.List (sort)
import Forgejo (AppEnv, ForgejoError (..), User (..), createRepository, runForgejo)
import Forgejo.Integration.Helpers (commitFile, createBranch, uniqueName, withCreatedRepo)
import Forgejo.Methods.PullRequest
  ( PullReviewRequestOptions (..)
  , addReviewer
  , createPullRequest
  , getPullRequestCommits
  , getPullRequestFiles
  )
import Forgejo.Types.ChangedFile (ChangedFile (..))
import Forgejo.Types.CreatePullRequestOption (CreatePullRequestOption (..))
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption (..))
import Forgejo.Types.PullRequest (PullRequest (..))
import Forgejo.Types.PullRequestCommit (PullRequestCommit (..))
import Forgejo.Types.Repository (Repository (..))
import Test.Hspec

spec :: SpecWith AppEnv
spec =
  aroundAllWith withPullRequest $ do
    describe "createPullRequest" $ do
      it "creates a pull request with the given title" $ \(_, _, pr) ->
        pr.prTitle `shouldBe` "Integration test PR"

      it "returns ErrConflict when a pull request for the branches already exists" $ \(env, r, _) -> do
        result <- runForgejo env $ createPullRequest r.repoOwner.userLogin r.repoName prOpt
        result `shouldSatisfy` \case
          Left ErrConflict{} -> True
          _ -> False

    describe "setReviewer"
      $ it "returns ErrValidation when the reviewer is the author"
      $ \(env, r, pr) -> do
        let owner = r.repoOwner.userLogin
        result <- runForgejo env . addReviewer $ PullReviewRequestOptions owner r.repoName pr.prNumber [owner] []
        result `shouldSatisfy` \case
          Left ErrValidation{} -> True
          _ -> False

    describe "getPullRequestFiles"
      $ it "reads every changed file across pages"
      $ \(env, r, pr) -> do
        result <- runForgejo env $ getPullRequestFiles r.repoOwner.userLogin r.repoName pr.prNumber (Just 1)
        case result of
          Left err -> expectationFailure $ show err
          Right files -> sort (map (.filename) files) `shouldBe` ["a.txt", "b.txt"]

    describe "getPullRequestCommits"
      $ it "reads every commit across pages, newest first"
      $ \(env, r, pr) -> do
        result <- runForgejo env $ getPullRequestCommits r.repoOwner.userLogin r.repoName pr.prNumber (Just 1)
        case result of
          Left err -> expectationFailure $ show err
          Right [newest, oldest] -> newest.pcParents `shouldBe` [oldest.pcSha1]
          Right commits -> expectationFailure $ "expected 2 commits, got " <> show (length commits)

-- ---------------------------------------------------------------------------

-- | Pull request from @feature@ to @main@.
prOpt :: CreatePullRequestOption
prOpt = CreatePullRequestOption "Integration test PR" "feature" "main" Nothing [] Nothing Nothing [] Nothing

{- | Create a throwaway repository with a @feature@ branch (two commits, one file each)
and a pull request from it to @main@, deleting the repository once every test in the group has run.
-}
withPullRequest :: ((AppEnv, Repository, PullRequest) -> IO ()) -> AppEnv -> IO ()
withPullRequest action env = do
  name <- uniqueName "hspec-pulls"
  -- NOTE: needs an initial commit on @main@, so the repository must be auto-initialised.
  withCreatedRepo env (createRepository $ CreateRepositoryOption "pull request integration tests" name True True) $ \r -> do
    createBranch env r "main" "feature"
    commitFile env r "feature" "a.txt" "add a.txt"
    commitFile env r "feature" "b.txt" "add b.txt"
    result <- runForgejo env $ createPullRequest r.repoOwner.userLogin r.repoName prOpt
    case result of
      Left err -> fail $ "setup failed: " <> show err
      Right pr -> action (env, r, pr)
