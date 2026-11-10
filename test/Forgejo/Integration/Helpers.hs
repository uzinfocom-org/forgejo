module Forgejo.Integration.Helpers (uniqueName, withCreatedRepo, createBranch, commitFile) where

import Control.Exception (bracket)
import Control.Monad (void)
import Data.Text (Text, pack)
import Data.Time.Clock.POSIX (getPOSIXTime)
import Forgejo (AppEnv, User (..), deleteRepository, runForgejo)
import Forgejo.App (AppM)
import Forgejo.Methods.Branch qualified as Branch
import Forgejo.Methods.Contents qualified as Contents
import Forgejo.Types.Repository (Repository (..))

-- | Millisecond-precision suffix so names stay unique across test runs.
uniqueName :: Text -> IO Text
uniqueName prefix = do
  ms <- round @Double @Int . (* 1000) . realToFrac <$> getPOSIXTime
  pure $ prefix <> "-" <> pack (show ms)

{- | Run an action with a freshly created repository, deleting it afterwards
even if the action throws. Fails the test immediately if creation fails.
-}
withCreatedRepo :: AppEnv -> AppM Repository -> (Repository -> IO a) -> IO a
withCreatedRepo env create =
  bracket
    (runForgejo env create >>= either (fail . show) pure)
    (\r -> void $ runForgejo env (deleteRepository r.repoOwner.userLogin r.repoName))

{- | Create a branch from another one. Fails the test immediately if it fails.

  Arguments: source branch, new branch.
-}
createBranch :: AppEnv -> Repository -> Text -> Text -> IO ()
createBranch env r from new =
  runForgejo env (Branch.createBranch r.repoOwner.userLogin r.repoName from new)
    >>= either (fail . show) pure

{- | Add one file to a branch as a single commit, so each call makes one commit.
Fails the test immediately if it fails.

  Arguments: branch, file path, commit message.
-}
commitFile :: AppEnv -> Repository -> Text -> Text -> Text -> IO ()
commitFile env r branch path message =
  runForgejo env (Contents.createFile r.repoOwner.userLogin r.repoName path branch message ("content of " <> path))
    >>= either (fail . show) pure
