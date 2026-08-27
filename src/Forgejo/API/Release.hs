module Forgejo.API.Release
  ( ReleaseRoutes (..)
  ) where

import Data.Text (Text)
import Forgejo.Types.APIError (APIError)
import Forgejo.Types.APIForbiddenError (APIForbiddenError)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.APIValidationError (APIValidationError)
import Forgejo.Types.CreateReleaseOption (CreateReleaseOption)
import Forgejo.Types.Release (Release)
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (Capture, JSON, NamedRoutes, ReqBody, UVerb, WithStatus, type (:-), type (:>))

data ReleaseRoutes route = ReleaseRoutes
  { createReleaseApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "releases"
          :> ReqBody '[JSON] CreateReleaseOption
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 201 Release
                , WithStatus 404 APINotFound
                , WithStatus 409 APIError
                , WithStatus 422 APIValidationError
                ]
  -- ^ POST /repos/{owner}/{repo}/releases
  }
  deriving stock (Generic)
