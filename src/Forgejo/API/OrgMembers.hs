module Forgejo.API.OrgMembers
  ( OrgMembersRoutes (..)
  ) where

import Data.Text (Text)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)
import Servant (Capture, Get, JSON, type (:-), type (:>))

data OrgMembersRoutes route = OrgMembersRoutes
  { getOrgMembersRoute :: route :- "orgs" :> Capture "org" Text :> "members" :> Get '[JSON] [User]
  }
  deriving stock (Generic)
