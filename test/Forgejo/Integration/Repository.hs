module Forgejo.Integration.Repository (spec) where

import Forgejo (AppEnv, ForgejoError (..), createRepository, runForgejo)
import Forgejo.Integration.Helpers (uniqueName, withCreatedRepo)
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption (..))
import Forgejo.Types.Repository (Repository (..))
import Test.Hspec

spec :: SpecWith AppEnv
spec = do
  it "creates a repository with the given name" $ \env -> do
    name <- uniqueName "hspec-repo"
    withCreatedRepo env (createRepository (CreateRepositoryOption "integration test" name False)) $ \r ->
      repoName r `shouldBe` name

  it "returns ErrConflict when the repository already exists" $ \env -> do
    name <- uniqueName "hspec-dup"
    let opt = CreateRepositoryOption "dup test" name False
    withCreatedRepo env (createRepository opt) $ \_ -> do
      result <- runForgejo env (createRepository opt)
      result `shouldSatisfy` \case
        Left (ErrConflict _ _) -> True
        _ -> False
