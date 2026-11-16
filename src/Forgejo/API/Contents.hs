module Forgejo.API.Contents
  ( ContentsRoutes (..)
  , CreateFileApiOption (..)
  ) where

import Data.Aeson (ToJSON (..), Value, object, (.=))
import Data.Aeson.Key (fromString)
import Data.ByteString (ByteString)
import Data.ByteString.Base64 (encode)
import Data.Text (Text)
import Data.Text.Encoding (decodeUtf8)
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
  { createFileContent :: ByteString
  -- ^ Base64 encoded content
  , createFileMessage :: Text
  -- ^ Commit message
  , createFileBranch :: Text
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreateFileApiOption where
  toJSON o =
    object
      [ fromString "content" .= (decodeUtf8 . encode) o.createFileContent
      , fromString "message" .= o.createFileMessage
      , fromString "branch" .= o.createFileBranch
      ]
