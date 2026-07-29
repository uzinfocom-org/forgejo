{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.LicensesTemplateListEntry
  ( LicensesTemplateListEntry (..)
  , LicensesTemplateListEntryPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data LicensesTemplateListEntry = LicensesTemplateListEntry
  { key :: Text
  , name :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON LicensesTemplateListEntry where
  parseJSON = withObject "LicensesTemplateListEntry" $ \o ->
    LicensesTemplateListEntry
      <$> o .: "key"
      <*> o .: "name"
      <*> o .: "url"

instance ToJSON LicensesTemplateListEntry where
  toJSON = genericToJSON runOptions

data LicensesTemplateListEntryPayload = LicensesTemplateListEntryPayload
  { arpAction :: Text
  , arpRun :: LicensesTemplateListEntry
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON LicensesTemplateListEntryPayload where
  parseJSON = withObject "LicensesTemplateListEntryPayload" $ \o ->
    LicensesTemplateListEntryPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON LicensesTemplateListEntryPayload where
  toJSON = genericToJSON arpOptions
