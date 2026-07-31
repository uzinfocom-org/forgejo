module Forgejo.Types.User
  ( User (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Common (SourceId, UserId)
import GHC.Generics (Generic)

userOptions :: Options
userOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}

data User = User
  { userId :: Int
  , userLogin :: Text
  , userLoginName :: Text
  , userSourceId :: SourceId
  , userFullName :: Text
  , userEmail :: Text
  , userAvatarUrl :: Text
  , userHtmlUrl :: Text
  , userLanguage :: Text
  , userIsAdmin :: Bool
  , userLastLogin :: UTCTime
  , userCreated :: UTCTime
  , userRestricted :: Bool
  , userActive :: Bool
  , userProhibitLogin :: Bool
  , userLocation :: Text
  , userPronouns :: Text
  , userWebsite :: Text
  , userDescription :: Text
  , userVisibility :: Text
  , userFollowersCount :: Int
  , userFollowingCount :: Int
  , userStarredReposCount :: Int
  , userUsername :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON User where
  parseJSON = genericParseJSON userOptions

instance ToJSON User where
  toJSON = genericToJSON userOptions
