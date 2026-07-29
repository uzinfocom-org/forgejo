{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ExternalTracker
  ( ExternalTracker (..)
  , ExternalTrackerPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data ExternalTracker = ExternalTracker
  { externalTrackerFormat :: Text
  , externalTrackerRegexpPattern :: Text
  , externalTrackerStyle :: Text
  , externalTrackerUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ExternalTracker where
  parseJSON = withObject "ExternalTracker" $ \o ->
    ExternalTracker
      <$> o .: "external_tracker_format"
      <*> o .: "external_tracker_regexp_pattern"
      <*> o .: "external_tracker_style"
      <*> o .: "external_tracker_url"

instance ToJSON ExternalTracker where
  toJSON = genericToJSON runOptions

data ExternalTrackerPayload = ExternalTrackerPayload
  { arpAction :: Text
  , arpRun :: ExternalTracker
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ExternalTrackerPayload where
  parseJSON = withObject "ExternalTrackerPayload" $ \o ->
    ExternalTrackerPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ExternalTrackerPayload where
  toJSON = genericToJSON arpOptions
