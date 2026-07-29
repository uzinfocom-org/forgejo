{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GeneralRepoSettings
  ( GeneralRepoSettings (..)
  , GeneralRepoSettingsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GeneralRepoSettings = GeneralRepoSettings
  { forksDisabled :: Bool
  , httpGitDisabled :: Bool
  , lfsDisabled :: Bool
  , migrationsDisabled :: Bool
  , mirrorsDisabled :: Bool
  , starsDisabled :: Bool
  , timeTrackingDisabled :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GeneralRepoSettings where
  parseJSON = withObject "GeneralRepoSettings" $ \o ->
    GeneralRepoSettings
      <$> o .: "forks_disabled"
      <*> o .: "http_git_disabled"
      <*> o .: "lfs_disabled"
      <*> o .: "migrations_disabled"
      <*> o .: "mirrors_disabled"
      <*> o .: "stars_disabled"
      <*> o .: "time_tracking_disabled"

instance ToJSON GeneralRepoSettings where
  toJSON = genericToJSON runOptions

data GeneralRepoSettingsPayload = GeneralRepoSettingsPayload
  { arpAction :: Text
  , arpRun :: GeneralRepoSettings
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GeneralRepoSettingsPayload where
  parseJSON = withObject "GeneralRepoSettingsPayload" $ \o ->
    GeneralRepoSettingsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GeneralRepoSettingsPayload where
  toJSON = genericToJSON arpOptions
