module Forgejo.Methods.Repository
  ( createRepository
  , deleteRepository
  ) where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (repos))
import Forgejo.API.Repository (RepoRoutes (..))
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

{- | Delete a repository.

  Possible errors:

  * 'ErrForbidden': token lacks repo deletion permission
  * 'ErrNotFound': owner or repository does not exist
-}
deleteRepository :: Text -> Text -> AppM ()
deleteRepository owner repo = do
  fg <- forgejo
  _ <- deleteRepositoryApi (repos fg) owner repo >>= liftResult
  pure ()
