module Forgejo.Types.CreatePullRequestOption (CreatePullRequestOption (..), withDefaultCreatePullRequestOption) where

import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Common (LabelId, MilestoneId)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

data CreatePullRequestOption = CreatePullRequestOption
  { cproTitle :: Text
  , cproHead :: Text
  , cproBase :: Text
  , cproAssignee :: Maybe User
  , cproAssignees :: [User]
  , cproBody :: Maybe Text
  , cproDueDate :: Maybe UTCTime
  , cproLabels :: [LabelId]
  , cproMilestone :: Maybe MilestoneId
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreatePullRequestOption where
  toJSON = genericToJSON (camelToSnake){omitNothingFields = True}
   where
    camelToSnake = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}

withDefaultCreatePullRequestOption :: Text -> Text -> Text -> CreatePullRequestOption
withDefaultCreatePullRequestOption title hd base = CreatePullRequestOption title hd base Nothing [] Nothing Nothing [] Nothing
