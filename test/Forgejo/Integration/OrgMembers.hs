module Forgejo.Integration.OrgMembers (spec) where

import Data.Text (Text)
import Data.Text qualified as T
import Forgejo (AppEnv, ForgejoError (..), User (..), getOrgMember, runForgejo)
import Test.Hspec

spec :: Maybe Text -> SpecWith AppEnv
spec mOrg =
  describe "getOrgMember" $ do
    case mOrg of
      Nothing ->
        it "lists organisation members (set FG_ORG to enable)" $ const pending
      Just org -> do
        it "returns a list of members for an existing organisation" $ \env -> do
          result <- runForgejo env $ getOrgMember org
          result `shouldSatisfy` \case
            Right _ -> True
            Left _ -> False

        it "returns at least one member" $ \env -> do
          result <- runForgejo env $ getOrgMember org
          case result of
            Left err -> expectationFailure $ show err
            Right members -> members `shouldSatisfy` (not . null)

        it "returns members with a non-empty login" $ \env -> do
          result <- runForgejo env $ getOrgMember org
          case result of
            Left err -> expectationFailure $ show err
            Right members -> map userLogin members `shouldSatisfy` (not . any T.null)

    it "returns ErrNotFound for a nonexistent organisation" $ \env -> do
      result <- runForgejo env (getOrgMember "org-xyz-does-not-exist")
      result `shouldSatisfy` \case
        Left ErrNotFound{} -> True
        _ -> False
