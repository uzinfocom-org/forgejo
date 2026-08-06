module Forgejo.API.CommitStatus
  ( CommitStatusRoutes (..)
  , CommitStatusState (..)
  , CreateCommitStatus (..)
  , CommitStatus (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), SumEncoding (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)
import Servant (Capture, JSON, Post, ReqBody, type (:-), type (:>))

data CommitStatusRoutes route = CommitStatusRoutes
  { createCommitStatusRoute
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "statuses"
          :> Capture "sha" Text
          :> ReqBody '[JSON] CreateCommitStatus
          :> Post '[JSON] CommitStatus
  }
  deriving stock (Generic)

data CommitStatusState = Pending | Success | Error | Failure | Warning
  deriving stock (Eq, Generic, Show)

instance ToJSON CommitStatusState where
  toJSON = genericToJSON defaultOptions{constructorTagModifier = camelTo2 '_', sumEncoding = UntaggedValue}

instance FromJSON CommitStatusState where
  parseJSON = genericParseJSON defaultOptions{constructorTagModifier = camelTo2 '_', sumEncoding = UntaggedValue}

data CreateCommitStatus = CreateCommitStatus
  { createStatusContext :: Text
  , createStatusDescription :: Text
  , createStatusState :: CommitStatusState
  , createStatusTargetUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreateCommitStatus where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 12}

data CommitStatus = CommitStatus
  { statusId :: Int
  , statusContext :: Text
  , statusDescription :: Text
  , statusState :: CommitStatusState
  , statusTargetUrl :: Text
  , statusUrl :: Text
  , statusCreatedAt :: UTCTime
  , statusUpdatedAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CommitStatus where
  parseJSON = genericParseJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 6}
