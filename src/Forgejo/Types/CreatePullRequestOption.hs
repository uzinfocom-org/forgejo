module Forgejo.Types.CreatePullRequestOption (CreatePullRequestOption (..)) where

import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

data CreatePullRequestOption = CreatePullRequestOption
  { cproAssignee :: Maybe Text
  , cproAssignees :: Maybe [Text]
  , cproBase :: Text
  , cproBody :: Maybe Text
  , cproDueDate :: Maybe UTCTime
  , cproHead :: Text
  , cproLabels :: Maybe [Int]
  , cproMilestone :: Maybe Int
  , cproTitle :: Text
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreatePullRequestOption where
  toJSON = genericToJSON (camelToSnake){omitNothingFields = True}
   where
    camelToSnake = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}
