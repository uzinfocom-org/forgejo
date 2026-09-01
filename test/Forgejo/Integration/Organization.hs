module Forgejo.Integration.Organization (spec) where

import Data.Text (Text)
import Forgejo (AppEnv, ForgejoError (..), createOrgRepository, getOrgMember, runForgejo)
import Forgejo.Integration.Helpers (uniqueName, withCreatedRepo)
import Forgejo.Types.CreateRepositoryOption (CreateOrgRepositoryOption (..), CreateRepositoryOption (..))
import Forgejo.Types.Repository (Repository (..))
import Test.Hspec

spec :: Maybe Text -> SpecWith AppEnv
spec Nothing = it "org tests (set FORGEJO_ORG to enable)" (\_env -> pending)
spec (Just org) = do
  describe "getOrgMember" $ do
    it "returns a list of members for an existing organisation" $ \env -> do
      result <- runForgejo env (getOrgMember org)
      result `shouldSatisfy` \case
        Right _ -> True
        Left _ -> False

    it "returns ErrNotFound for a nonexistent organisation" $ \env -> do
      result <- runForgejo env (getOrgMember "org-xyz-does-not-exist")
      result `shouldSatisfy` \case
        Left (ErrNotFound _ _ _) -> True
        _ -> False

  describe "createOrgRepository"
    $ it "creates a repository in the organisation"
    $ \env -> do
      name <- uniqueName "hspec-org-repo"
      let opt = CreateOrgRepositoryOption org (CreateRepositoryOption "integration test" name False)
      withCreatedRepo env (createOrgRepository opt) $ \r ->
        repoName r `shouldBe` name
