module Forgejo.Methods.CommitStatus
  ( createCommitStatus
  ) where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (statuses))
import Forgejo.API.CommitStatus (CommitStatus, CommitStatusRoutes (createCommitStatusRoute), CreateCommitStatus)
import Forgejo.App (AppM, forgejo)
import Forgejo.Error

{- | Set a commit status on a specific SHA.

  Possible errors:

  * 'ErrBadRequest': malformed status payload
-}
createCommitStatus :: Text -> Text -> Text -> CreateCommitStatus -> AppM CommitStatus
createCommitStatus owner repo sha status = do
  fg <- forgejo
  createCommitStatusRoute (statuses fg) owner repo sha status >>= liftResult
