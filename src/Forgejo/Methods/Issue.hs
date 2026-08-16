-- | This module contains all issue related APIs.
module Forgejo.Methods.Issue
  ( createIssue
  ) where

import Forgejo.API (ForgejoRoutes (issues))
import Forgejo.API.Issue (IssueRoutes (createIssueApi))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.Issue (Issue)

--

{- | Create an issue in a repository.

  Possible errors:

  * 'ErrForbidden': token lacks write access to issues
  * 'ErrNotFound': owner or repository does not exist
  * 'ErrConflict': issue with same reference already exists
  * 'ErrValidation': title is empty, or label\/milestone IDs are invalid
  * 'ErrRepoArchived': repository is archived
-}
createIssue :: CreateIssueOption -> AppM Issue
createIssue CreateIssueOption{..} = do
  fg <- forgejo
  createIssueApi (issues fg) cioOwner cioRepo cioApiJson >>= liftResult
