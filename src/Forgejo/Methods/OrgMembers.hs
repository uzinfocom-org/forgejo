module Forgejo.Methods.OrgMembers (getOrgMember) where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (orgMembers))
import Forgejo.API.OrgMembers (OrgMembersRoutes (getOrgMembersRoute))
import Forgejo.App (AppM, forgejo)
import Forgejo.Types.User (User)

getOrgMember :: Text -> AppM [User]
getOrgMember org = do
  fg <- forgejo
  getOrgMembersRoute (orgMembers fg) org
