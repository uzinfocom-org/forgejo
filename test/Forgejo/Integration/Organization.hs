module Forgejo.Integration.Organization (spec) where

import Data.Text (Text)
import Forgejo.App (AppEnv, runForgejo)
import Forgejo.Error (ForgejoError (..))
import Forgejo.Integration.Helpers (uniqueName, withCreatedRepo)
import Forgejo.Methods.OrgMembers (getOrgMember)
import Forgejo.Methods.Organization (createOrgRepository)
import Forgejo.Types.CreateRepositoryOption (CreateOrgRepositoryOption (..), CreateRepositoryOption (..))
import Forgejo.Types.Repository (Repository (..))
import Forgejo.Types.User (User (..))
import Test.Hspec

spec :: Maybe Text -> SpecWith AppEnv
spec Nothing = it "org tests (set FG_ORG to enable)" $ const pending
spec (Just org) = do
  describe "getOrgMember" $ do
    it "returns a list of members for an existing organisation" $ \env -> do
      result <- runForgejo env $ getOrgMember org
      result `shouldSatisfy` \case
        Right _ -> True
        Left _ -> False

    it "returns ErrNotFound for a nonexistent organisation" $ \env -> do
      result <- runForgejo env $ getOrgMember "org-xyz-does-not-exist"
      result `shouldSatisfy` \case
        Left ErrNotFound{} -> True
        _ -> False

  describe "createOrgRepository" $ do
    it "creates a repository in the organisation" $ \env -> do
      name <- uniqueName "hspec-org-repo"
      withCreatedRepo env (createOrgRepository $ orgOpt org name) $ \r ->
        repoName r `shouldBe` name

    it "sets the organisation as the repository owner" $ \env -> do
      name <- uniqueName "hspec-org-owner"
      withCreatedRepo env (createOrgRepository $ orgOpt org name) $ \r ->
        userLogin (repoOwner r) `shouldBe` org

    it "returns ErrConflict when the repository already exists" $ \env -> do
      name <- uniqueName "hspec-org-dup"
      withCreatedRepo env (createOrgRepository $ orgOpt org name) $ \_ -> do
        result <- runForgejo env . createOrgRepository $ orgOpt org name
        result `shouldSatisfy` \case
          Left ErrConflict{} -> True
          _ -> False

    it "returns ErrValidation for a nonexistent organisation" $ \env -> do
      name <- uniqueName "hspec-org-ghost"
      result <- runForgejo env . createOrgRepository $ orgOpt "org-xyz-does-not-exist" name
      result `shouldSatisfy` \case
        Left ErrValidation{} -> True
        _ -> False
 where
  orgOpt :: Text -> Text -> CreateOrgRepositoryOption
  orgOpt orgn name = CreateOrgRepositoryOption orgn (CreateRepositoryOption "org integration test" name False False)
