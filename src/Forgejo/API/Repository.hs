module Forgejo.API.Repository
  ( RepoRoutes (..)
  , RepoDeleted (..)
  ) where

import Data.Aeson (FromJSON (..))
import Data.Text (Text)
import Forgejo.Types.APIError (APIError)
import Forgejo.Types.APIForbiddenError (APIForbiddenError)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.APIValidationError (APIValidationError)
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption)
import Forgejo.Types.Repository (Repository)
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (Capture, JSON, ReqBody, UVerb, WithStatus, type (:-), type (:>))

-- Question: Maybe we can write separated types ? or type for deleted responses

-- | Phantom type for the 204 response of DELETE /repos/{owner}/{repo}. Because not implemented...
data RepoDeleted = RepoDeleted
  deriving stock (Generic, Show)

instance FromJSON RepoDeleted where
  parseJSON _ = pure RepoDeleted

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
  , deleteRepositoryApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> UVerb
               'DELETE
               '[JSON]
               '[ WithStatus 204 RepoDeleted
                , WithStatus 403 APIForbiddenError
                , WithStatus 404 APINotFound
                ]
  -- ^ DELETE /repos/{owner}/{repo}
  }
  deriving stock (Generic)
