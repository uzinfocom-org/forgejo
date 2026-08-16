module Forgejo.API.OrgMembers
  ( OrgMembersRoutes (..)
  ) where

import Data.Text (Text)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (Capture, JSON, UVerb, WithStatus, type (:-), type (:>))

data OrgMembersRoutes route = OrgMembersRoutes
  { getOrgMembersRoute
      :: route
        :- "orgs"
          :> Capture "org" Text
          :> "members"
          :> UVerb
               'GET
               '[JSON]
               '[ WithStatus 200 [User]
                , WithStatus 404 APINotFound
                ]
  }
  deriving stock (Generic)
