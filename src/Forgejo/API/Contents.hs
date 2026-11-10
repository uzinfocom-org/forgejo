module Forgejo.API.Contents
  ( ContentsRoutes (..)
  , CreateFileApiOption (..)
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

data ContentsRoutes route = ContentsRoutes
  { createFileApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "contents"
          :> Capture "filepath" Text
          :> ReqBody '[JSON] CreateFileApiOption
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 201 Value
                , WithStatus 403 APIForbiddenError
                , WithStatus 404 APINotFound
                , WithStatus 409 APIError
                , WithStatus 422 APIValidationError
                ]
  -- ^ POST /repos/{owner}/{repo}/contents/{filepath}
  }
  deriving stock (Generic)

data CreateFileApiOption = CreateFileApiOption
  { createFileContent :: Text
  -- ^ Base64 encoded content
  , createFileMessage :: Text
  -- ^ Commit message
  , createFileBranch :: Text
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreateFileApiOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 10}
