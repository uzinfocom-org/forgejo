module Forgejo.Types.CommitStatus
  ( CommitStatus (..)
  , CommitStatusState (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Char (toLower)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

data CommitStatusState = Pending | Success | Error | Failure | Warning | Skipped
  deriving stock (Eq, Generic, Show)

stateOptions :: Options
stateOptions = defaultOptions{constructorTagModifier = map toLower}

instance FromJSON CommitStatusState where
  parseJSON = genericParseJSON stateOptions

instance ToJSON CommitStatusState where
  toJSON = genericToJSON stateOptions

csOptions :: Options
csOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

data CommitStatus = CommitStatus
  { csContext :: Text
  , csCreatedAt :: UTCTime
  , csCreator :: User
  , csDescription :: Text
  , csId :: Int
  , csStatus :: CommitStatusState
  , csTargetUrl :: Text
  , csUpdatedAt :: UTCTime
  , csUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CommitStatus where
  parseJSON = genericParseJSON csOptions

instance ToJSON CommitStatus where
  toJSON = genericToJSON csOptions
