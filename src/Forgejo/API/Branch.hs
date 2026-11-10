module Forgejo.API.Branch
  ( BranchRoutes (..)
  , CreateBranchApiOption (..)
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
          :> ReqBody '[JSON] CreateBranchApiOption
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

data CreateBranchApiOption = CreateBranchApiOption
  { newBranchName :: Text
  , oldRefName :: Maybe Text
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreateBranchApiOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_'}
