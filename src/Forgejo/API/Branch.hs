module Forgejo.API.Branch
  ( BranchRoutes (..)
  , CreateBranchRepoOption (..)
  ) where

import Data.Aeson (ToJSON (..), Value, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.APIError (APIError)
import Forgejo.Types.APIForbiddenError (APIForbiddenError)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.APIValidationError (APIValidationError)
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (Capture, JSON, ReqBody, UVerb, WithStatus, type (:-), type (:>))

data BranchRoutes route = BranchRoutes
  { createBranchApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "branches"
          :> ReqBody '[JSON] CreateBranchRepoOption
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 201 Value
                , WithStatus 403 APIForbiddenError
                , WithStatus 404 APINotFound
                , WithStatus 409 APIError
                , WithStatus 422 APIValidationError
                ]
  -- ^ POST /repos/{owner}/{repo}/branches
  }
  deriving stock (Generic)

data CreateBranchRepoOption = CreateBranchRepoOption
  { newBranchName :: Text
  , oldRefName :: Maybe Text
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreateBranchRepoOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_', omitNothingFields = True}
