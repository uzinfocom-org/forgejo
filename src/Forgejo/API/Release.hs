module Forgejo.API.Release (ReleaseRoutes (..)) where

import Data.Text (Text)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.Common (ReleaseId (..))
import Forgejo.Types.EditReleaseOption (EditReleaseOption)
import Forgejo.Types.Release (Release)
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (Capture, JSON, ReqBody, UVerb, WithStatus, type (:-), type (:>))

data ReleaseRoutes route = ReleaseRoutes
  { editReleaseApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "releases"
          :> Capture "id" ReleaseId
          :> ReqBody '[JSON] EditReleaseOption
          :> UVerb
               'PATCH
               '[JSON]
               '[ WithStatus 200 Release
                , WithStatus 404 APINotFound
                ]
  -- ^ PATCH /repos/{owner}/{repo}/releases/{id}
  }
  deriving stock (Generic)
