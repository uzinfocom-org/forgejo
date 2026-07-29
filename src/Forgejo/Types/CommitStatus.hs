{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CommitStatus
  ( CommitStatus (..)
  , CommitStatusPayload (..)
  , CommitStatusState
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CommitStatusState = Pending | Success | Failure | Warning
  deriving (Eq, FromJSON, Generic, Show, ToJSON)

data CommitStatus = CommitStatus
  { context :: Text
  , createdAt :: UTCTime
  , creator :: User
  , description :: Text
  , id :: Int
  , status :: CommitStatusState
  , targetUrl :: Text
  , updatedAt :: UTCTime
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CommitStatus where
  parseJSON = withObject "CommitStatus" $ \o ->
    CommitStatus
      <$> o .: "context"
      <*> o .: "created_at"
      <*> o .: "creator"
      <*> o .: "description"
      <*> o .: "id"
      <*> o .: "status"
      <*> o .: "target_url"
      <*> o .: "updated_at"
      <*> o .: "url"

instance ToJSON CommitStatus where
  toJSON = genericToJSON runOptions

data CommitStatusPayload = CommitStatusPayload
  { arpAction :: Text
  , arpRun :: CommitStatus
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CommitStatusPayload where
  parseJSON = withObject "CommitStatusPayload" $ \o ->
    CommitStatusPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CommitStatusPayload where
  toJSON = genericToJSON arpOptions
