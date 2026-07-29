{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GeneralAttachmentSettings
  ( GeneralAttachmentSettings (..)
  , GeneralAttachmentSettingsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GeneralAttachmentSettings = GeneralAttachmentSettings
  { allowedTypes :: Text
  , enabled :: Bool
  , maxFiles :: Int
  , maxSize :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GeneralAttachmentSettings where
  parseJSON = withObject "GeneralAttachmentSettings" $ \o ->
    GeneralAttachmentSettings
      <$> o .: "allowed_types"
      <*> o .: "enabled"
      <*> o .: "max_files"
      <*> o .: "max_size"

instance ToJSON GeneralAttachmentSettings where
  toJSON = genericToJSON runOptions

data GeneralAttachmentSettingsPayload = GeneralAttachmentSettingsPayload
  { arpAction :: Text
  , arpRun :: GeneralAttachmentSettings
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GeneralAttachmentSettingsPayload where
  parseJSON = withObject "GeneralAttachmentSettingsPayload" $ \o ->
    GeneralAttachmentSettingsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GeneralAttachmentSettingsPayload where
  toJSON = genericToJSON arpOptions
