module Forgejo.Methods.Organization
  ( createOrgRepository
  ) where

import Forgejo.API (ForgejoRoutes (orgs))
import Forgejo.API.Organization (OrgRoutes (..))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.CreateRepositoryOption (CreateOrgRepositoryOption (..))
import Forgejo.Types.Repository (Repository)

{- | Create a repository under an organisation.

  Possible errors:

  * 'ErrForbidden': token lacks org repo creation permission
  * 'ErrNotFound': organisation does not exist
  * 'ErrConflict': repository with that name already exists
  * 'ErrValidation': organisation does not exist, or the repository name or settings are invalid
-}
createOrgRepository :: CreateOrgRepositoryOption -> AppM Repository
createOrgRepository CreateOrgRepositoryOption{..} = do
  fg <- forgejo
  createOrgRepositoryApi (orgs fg) coroOwner coroApiJson >>= liftResult
