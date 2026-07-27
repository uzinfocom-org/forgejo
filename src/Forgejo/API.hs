module Forgejo.API
  ( AuthHeader
  , ForgejoRoutes (..)
  , ForgejoAPI (..)
  ) where

import Data.Text (Text)
import Forgejo.API.CommitStatus (CommitStatusRoutes)
import Forgejo.API.OrgMembers (OrgMembersRoutes)
import Forgejo.API.PullRequest (PullRequestRoutes)
import GHC.Generics (Generic)
import Servant (Header', NamedRoutes, Required, Strict, type (:-), type (:>))

type AuthHeader = Header' '[Required, Strict] "Authorization" Text

data ForgejoRoutes route = ForgejoRoutes
  { orgMembers :: route :- NamedRoutes OrgMembersRoutes
  , pulls :: route :- NamedRoutes PullRequestRoutes
  , statuses :: route :- NamedRoutes CommitStatusRoutes
  }
  deriving stock (Generic)

data ForgejoAPI route = ForgejoAPI
  { v1 :: route :- "api" :> "v1" :> AuthHeader :> NamedRoutes ForgejoRoutes
  }
  deriving stock (Generic)
