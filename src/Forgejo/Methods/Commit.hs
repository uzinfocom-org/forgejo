-- | This module contains all commit related APIs.
module Forgejo.Methods.Commit
  ( createCommitStatus
  ) where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (commits))
import Forgejo.API.Commit (CommitRoutes (..))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.CommitStatus (CommitStatus)
import Forgejo.Types.CreateStatusOption (CreateStatusOption)

{- | Set a commit status on a specific SHA.

  Possible errors:

  * 'ErrBadRequest': malformed status payload
  * 'ErrNotFound': owner, repository or sha does not exist
-}
createCommitStatus :: Text -> Text -> Text -> CreateStatusOption -> AppM CommitStatus
createCommitStatus owner repo sha opt = do
  fg <- forgejo
  createCommitStatusApi (commits fg) owner repo sha opt >>= liftResult
