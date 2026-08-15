module Forgejo.Methods.Repository
  ( createRepository
  ) where

import Forgejo.API (ForgejoRoutes (repos))
import Forgejo.API.Repository (RepoRoutes (createRepositoryApi))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption (..))
import Forgejo.Types.Repository (Repository)

{- | Create a repository for the authenticated user.

  Possible errors:

  * 'ErrBadRequest': malformed request body
  * 'ErrForbidden': token lacks repo creation permission
  * 'ErrNotFound': authenticated user not found
  * 'ErrConflict': repository with that name already exists
  * 'ErrValidation': invalid repository name or settings
-}
createRepository :: CreateRepositoryOption -> AppM Repository
createRepository c = do
  fg <- forgejo
  createRepositoryApi (repos fg) c >>= liftResult
