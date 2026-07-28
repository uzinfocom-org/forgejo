{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GeneralUISettings
  ( GeneralUISettings (..)
  , GeneralUISettingsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GeneralUISettings = GeneralUISettings
  { allowedReactions :: [Text]
  , customEmojis :: [Text]
  , defaultTheme :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GeneralUISettings where
  parseJSON = withObject "GeneralUISettings" $ \o ->
    GeneralUISettings
      <$> o .: "allowed_reactions"
      <*> o .: "custom_emojis"
      <*> o .: "default_theme"

instance ToJSON GeneralUISettings where
  toJSON = genericToJSON runOptions

data GeneralUISettingsPayload = GeneralUISettingsPayload
  { arpAction :: Text
  , arpRun :: GeneralUISettings
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GeneralUISettingsPayload where
  parseJSON = withObject "GeneralUISettingsPayload" $ \o ->
    GeneralUISettingsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GeneralUISettingsPayload where
  toJSON = genericToJSON arpOptions
