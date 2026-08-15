module Forgejo.Methods.OrgMembers (getOrgMember) where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (orgMembers))
import Forgejo.API.OrgMembers (OrgMembersRoutes (getOrgMembersRoute))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.User (User)

{- | List members of an organisation.

  Possible errors:

  * 'ErrNotFound': organisation does not exist
-}
getOrgMember :: Text -> AppM [User]
getOrgMember org = do
  fg <- forgejo
  getOrgMembersRoute (orgMembers fg) org >>= liftResult
