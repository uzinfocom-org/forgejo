module Forgejo.API.Organization
  ( OrgRoutes (..)
  , GetOrgRepositoryApiOption
  , GetOrgRepositoryOption (..)
  ) where

import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
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
  , getOrgReposApi
      :: route
        :- "org"
          :> Capture "org" Text
          :> "repos"
          :> ReqBody '[JSON] (Maybe GetOrgRepositoryApiOption)
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 200 [Repository]
                , WithStatus 404 APINotFound
                ]
  -- ^ GET /org/{org}/repos
  }
  deriving stock (Generic)

data GetOrgRepositoryApiOption = GetOrgRepositoryApiOption
  { goroPage :: Maybe Int
  , goroLimit :: Maybe Int
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON GetOrgRepositoryApiOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}

data GetOrgRepositoryOption = GetOrgRepositoryOption
  { goroOrg :: Text
  , goroApiJson :: Maybe GetOrgRepositoryApiOption
  }
