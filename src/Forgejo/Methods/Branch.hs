module Forgejo.Methods.Branch (createBranch) where

import Control.Monad (void)
import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (branches))
import Forgejo.API.Branch (BranchRoutes (createBranchApi), CreateBranchApiOption (..))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error

{- | Create a branch from an existing branch or ref.

  Possible errors:

  * 'ErrForbidden': token lacks write access
  * 'ErrNotFound': owner, repository or the source branch does not exist
  * 'ErrConflict': branch already exists
-}
createBranch :: Text -> Text -> Text -> Text -> AppM ()
createBranch owner repo from new = do
  fg <- forgejo
  void $ createBranchApi (branches fg) owner repo (CreateBranchApiOption new (Just from)) >>= liftResult
