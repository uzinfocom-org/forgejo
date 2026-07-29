{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditTagProtectionOption
  ( EditTagProtectionOption (..)
  , EditTagProtectionOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditTagProtectionOption = EditTagProtectionOption
  { namePattern :: Text
  , whitelistTeams :: [Text]
  , whitelistUsernames :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditTagProtectionOption where
  parseJSON = withObject "EditTagProtectionOption" $ \o ->
    EditTagProtectionOption
      <$> o .: "name_pattern"
      <*> o .: "whitelist_teams"
      <*> o .: "whitelist_usernames"

instance ToJSON EditTagProtectionOption where
  toJSON = genericToJSON runOptions

data EditTagProtectionOptionPayload = EditTagProtectionOptionPayload
  { arpAction :: Text
  , arpRun :: EditTagProtectionOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditTagProtectionOptionPayload where
  parseJSON = withObject "EditTagProtectionOptionPayload" $ \o ->
    EditTagProtectionOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditTagProtectionOptionPayload where
  toJSON = genericToJSON arpOptions
