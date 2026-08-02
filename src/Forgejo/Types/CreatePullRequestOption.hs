import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

data CreatePullRequestOption = CreatePullRequestOption
  { assignee :: Maybe Text
  , assignees :: Maybe [Text]
  , base :: Text
  , body :: Maybe Text
  , dueDate :: Maybe UTCTime
  , head :: Text
  , labels :: Maybe [Int]
  , milestone :: Maybe Int
  , title :: Text
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreatePullRequestOption where
  toJSON = genericToJSON (camelToSnake){omitNothingFields = True}
   where
    camelToSnake = defaultOptions{fieldLabelModifier = camelTo2 '_'}
