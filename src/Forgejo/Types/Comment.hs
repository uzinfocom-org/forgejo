module Forgejo.Types.Comment
  ( Comment (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value, genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Common (CommentId, UserId)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

commentOptions :: Options
commentOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 7}

data Comment = Comment
  { commentId :: CommentId
  , commentHtmlUrl :: Text
  , commentPullRequestUrl :: Text
  , commentIssueUrl :: Text
  , commentUser :: User
  , commentOriginalAuthor :: Text
  , commentOriginalAuthorId :: UserId
  , commentBody :: Text
  , commentAssets :: [Value]
  , commentCreatedAt :: UTCTime
  , commentUpdatedAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Comment where
  parseJSON = genericParseJSON commentOptions

instance ToJSON Comment where
  toJSON = genericToJSON commentOptions
