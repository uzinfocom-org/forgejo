{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.InternalTracker
  ( InternalTracker (..)
  , InternalTrackerPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data InternalTracker = InternalTracker
  { allowOnlyContributorsToTrackTime :: Bool
  , enableIssueDependencies :: Bool
  , enableTimeTracker :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON InternalTracker where
  parseJSON = withObject "InternalTracker" $ \o ->
    InternalTracker
      <$> o .: "allow_only_contributors_to_track_time"
      <*> o .: "enable_issue_dependencies"
      <*> o .: "enable_time_tracker"

instance ToJSON InternalTracker where
  toJSON = genericToJSON runOptions

data InternalTrackerPayload = InternalTrackerPayload
  { arpAction :: Text
  , arpRun :: InternalTracker
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON InternalTrackerPayload where
  parseJSON = withObject "InternalTrackerPayload" $ \o ->
    InternalTrackerPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON InternalTrackerPayload where
  toJSON = genericToJSON arpOptions
