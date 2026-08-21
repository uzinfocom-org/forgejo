module Forgejo.Methods.Organization
  ( createOrgRepository
  , getOrgRepos
  ) where

import Forgejo.API
import Forgejo.API.Organization (OrgRoutes (..), GetOrgRepositoryOption (..))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.CreateRepositoryOption (CreateOrgRepositoryOption (..))
import Forgejo.Types.Repository (Repository)

{- | Create a repository under an organisation.

  Possible errors:

  * 'ErrForbidden': token lacks org repo creation permission
  * 'ErrNotFound': organisation does not exist
  * 'ErrConflict': repository with that name already exists
-}
createOrgRepository :: CreateOrgRepositoryOption -> AppM Repository
createOrgRepository CreateOrgRepositoryOption{..} = do
  fg <- forgejo
  createOrgRepositoryApi (orgs fg) coroOwner coroApiJson >>= liftResult

getOrgRepos :: GetOrgRepositoryOption -> AppM [Repository]
getOrgRepos GetOrgRepositoryOption{..} = do
  fg <- forgejo
  getOrgReposApi (orgs fg) goroOrg goroApiJson >>= liftResult
