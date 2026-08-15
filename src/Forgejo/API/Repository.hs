module Forgejo.API.Repository
  ( RepoRoutes (..)
  ) where

import Forgejo.Types.APIError (APIError)
import Forgejo.Types.APIForbiddenError (APIForbiddenError)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.APIValidationError (APIValidationError)
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption)
import Forgejo.Types.Repository (Repository)
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (JSON, ReqBody, UVerb, WithStatus, type (:-), type (:>))

data RepoRoutes route = RepoRoutes
  { createRepositoryApi
      :: route
        :- "repos"
          :> ReqBody '[JSON] CreateRepositoryOption
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 201 Repository
                , WithStatus 400 APIError
                , WithStatus 403 APIForbiddenError
                , WithStatus 404 APINotFound
                , WithStatus 409 APIError
                , WithStatus 422 APIValidationError
                ]
  -- ^ POST /user/repos
  }
  deriving stock (Generic)
