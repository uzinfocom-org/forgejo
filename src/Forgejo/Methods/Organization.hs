module Forgejo.Methods.Organization
  ( createOrgRepository
  ) where

import Forgejo.API (ForgejoRoutes (orgs))
import Forgejo.API.Organization (OrgRoutes (..))
import Forgejo.App (AppM, forgejo)
import Forgejo.Types.CreateRepositoryOption (CreateOrgRepositoryOption (..))
import Forgejo.Types.Repository (Repository)

createOrgRepository :: CreateOrgRepositoryOption -> (AppM [Repository])
createOrgRepository c = do
  fg <- forgejo
  createOrgRepositoryApi (orgs fg) owner apiJson
 where
  owner = c.coroOwner
  apiJson = c.coroApiJson
