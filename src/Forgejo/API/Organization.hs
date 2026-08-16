module Forgejo.API.Organization
  ( OrgRoutes (..)
  ) where

import Data.Text (Text)
import Forgejo.Types.APIError (APIError)
import Forgejo.Types.APIForbiddenError (APIForbiddenError)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption)
import Forgejo.Types.Repository (Repository)
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (Capture, JSON, ReqBody, UVerb, WithStatus, type (:-), type (:>))

data OrgRoutes route = OrgRoutes
  { createOrgRepositoryApi
      :: route
        :- "org"
          :> Capture "org" Text
          :> "repos"
          :> ReqBody '[JSON] CreateRepositoryOption
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 201 Repository
                , WithStatus 403 APIForbiddenError
                , WithStatus 404 APINotFound
                , WithStatus 409 APIError
                ]
  -- ^ POST /org/{org}/repos
  }
  deriving stock (Generic)
