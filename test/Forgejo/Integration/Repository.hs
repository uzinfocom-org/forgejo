module Forgejo.Integration.Repository (spec) where

import Forgejo (AppEnv, ForgejoError (..), createRepository, deleteRepository, runForgejo)
import Forgejo.Integration.Helpers (uniqueName, withCreatedRepo)
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption (..))
import Forgejo.Types.Repository (Repository (..))
import Forgejo.Types.User (User (userLogin))
import Test.Hspec

spec :: SpecWith AppEnv
spec = do
  describe "createRepository" $ do
    it "creates a repository with the given name" $ \env -> do
      name <- uniqueName "hspec-repo"
      withCreatedRepo env (createRepository $ CreateRepositoryOption "integration test" name False) $ \r -> do
        repoName r `shouldBe` name

    it "returns ErrConflict when the repository already exists" $ \env -> do
      name <- uniqueName "hspec-dup"
      let opt = CreateRepositoryOption "dup test" name False
      withCreatedRepo env (createRepository opt) $ \_ -> do
        result <- runForgejo env $ createRepository opt
        result `shouldSatisfy` \case
          Left (ErrConflict _ _) -> True
          _ -> False

    it "returns ErrValidation for an invalid repository name" $ \env -> do
      result <- runForgejo env . createRepository $ CreateRepositoryOption "bad name" "not a valid/name!" False
      result `shouldSatisfy` \case
        Left ErrValidation{} -> True
        _ -> False

  describe "deleteRepository" $ do
    it "deletes an existing repository" $ \env -> do
      name <- uniqueName "hspec-del"
      created <- runForgejo env . createRepository $ CreateRepositoryOption "delete test" name False
      case created of
        Left e -> expectationFailure $ "setup failed: " <> show e
        Right r -> do
          result <- runForgejo env (deleteRepository (userLogin $ repoOwner r) (repoName r))
          result `shouldSatisfy` \case
            Right () -> True
            _ -> False

    it "returns ErrNotFound when deleting the same repository twice" $ \env -> do
      name <- uniqueName "hspec-del2"
      created <- runForgejo env . createRepository $ CreateRepositoryOption "delete twice" name False
      case created of
        Left e -> expectationFailure $ "setup failed: " <> show e
        Right r -> do
          let owner = userLogin $ repoOwner r
          _ <- runForgejo env $ deleteRepository owner $ repoName r
          second <- runForgejo env $ deleteRepository owner $ repoName r
          second `shouldSatisfy` \case
            Left ErrNotFound{} -> True
            _ -> False
