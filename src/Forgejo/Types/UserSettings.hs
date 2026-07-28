{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.UserSettings
  ( UserSettings (..)
  , UserSettingsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data UserSettings = UserSettings
  { description :: Text
  , diffViewStyle :: Text
  , enableRepoUnitHints :: Bool
  , fullName :: Text
  , hideActivity :: Bool
  , hideEmail :: Text
  , hidePronouns :: Bool
  , language :: Bool
  , location :: Text
  , pronouns :: Text
  , theme :: Text
  , website :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON UserSettings where
  parseJSON = withObject "UserSettings" $ \o ->
    UserSettings
      <$> o .: "description"
      <*> o .: "diff_view_style"
      <*> o .: "enable_repo_unit_hints"
      <*> o .: "full_name"
      <*> o .: "hide_activity"
      <*> o .: "hide_email"
      <*> o .: "hide_pronouns"
      <*> o .: "language"
      <*> o .: "location"
      <*> o .: "pronouns"
      <*> o .: "theme"
      <*> o .: "website"

instance ToJSON UserSettings where
  toJSON = genericToJSON runOptions

data UserSettingsPayload = UserSettingsPayload
  { arpAction :: Text
  , arpRun :: UserSettings
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON UserSettingsPayload where
  parseJSON = withObject "UserSettingsPayload" $ \o ->
    UserSettingsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON UserSettingsPayload where
  toJSON = genericToJSON arpOptions
