module Forgejo.Integration.Commit (spec) where

import Data.Text (Text)
import Forgejo (AppEnv, ForgejoError (..), User (..), createRepository, runForgejo)
import Forgejo.Integration.Helpers (uniqueName, withCreatedRepo)
import Forgejo.Methods.Commit (createCommitStatus)
import Forgejo.Types.CommitStatus (CommitStatusState (..))
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption (..))
import Forgejo.Types.CreateStatusOption (CreateStatusOption (..))
import Forgejo.Types.Repository (Repository (..))
import Test.Hspec

spec :: SpecWith AppEnv
spec =
  describe "createCommitStatus"
    $ it "returns ErrNotFound for a nonexistent sha in an existing repository"
    $ \env -> do
      name <- uniqueName "hspec-commit"
      withCreatedRepo env (createRepository $ CreateRepositoryOption "commit tests" name False False) $ \r -> do
        result <- runForgejo env $ createCommitStatus r.repoOwner.userLogin r.repoName missingSha statusOpt
        result `shouldSatisfy` \case
          Left ErrNotFound{} -> True
          _ -> False

missingSha :: Text
missingSha = "0000000000000000000000000000000000000000"

statusOpt :: CreateStatusOption
statusOpt = CreateStatusOption "hspec/ci" "integration test status" Pending "https://example.com"
