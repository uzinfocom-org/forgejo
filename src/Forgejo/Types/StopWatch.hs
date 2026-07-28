{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.StopWatch
  ( StopWatch (..)
  , StopWatchPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data StopWatch = StopWatch
  { created :: UTCTime
  , duration :: Text
  , issueIndex :: Int
  , issueTitle :: Text
  , repoName :: Text
  , repoOwnerName :: Text
  , seconds :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON StopWatch where
  parseJSON = withObject "StopWatch" $ \o ->
    StopWatch
      <$> o .: "created"
      <*> o .: "duration"
      <*> o .: "issue_index"
      <*> o .: "issue_title"
      <*> o .: "repo_name"
      <*> o .: "repo_owner_name"
      <*> o .: "seconds"

instance ToJSON StopWatch where
  toJSON = genericToJSON runOptions

data StopWatchPayload = StopWatchPayload
  { arpAction :: Text
  , arpRun :: StopWatch
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON StopWatchPayload where
  parseJSON = withObject "StopWatchPayload" $ \o ->
    StopWatchPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON StopWatchPayload where
  toJSON = genericToJSON arpOptions
