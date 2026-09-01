module Forgejo.Integration.Helpers (uniqueName, withCreatedRepo) where

import Control.Exception (bracket)
import Control.Monad (void)
import Data.Text (Text, pack)
import Data.Time.Clock.POSIX (getPOSIXTime)
import Forgejo (AppEnv, User (..), deleteRepository, runForgejo)
import Forgejo.App (AppM)
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
withCreatedRepo env create action =
  bracket
    (runForgejo env create >>= either (fail . show) pure)
    (\r -> void $ runForgejo env (deleteRepository r.repoOwner.userLogin r.repoName))
    action
