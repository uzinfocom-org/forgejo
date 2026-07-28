{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateTagProtectionOption
  ( CreateTagProtectionOption (..)
  , CreateTagProtectionOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateTagProtectionOption = CreateTagProtectionOption
  { namePattern :: Text
  , whitelistTeams :: [Text]
  , whitelistUsernames :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateTagProtectionOption where
  parseJSON = withObject "CreateTagProtectionOption" $ \o ->
    CreateTagProtectionOption
      <$> o .: "name_pattern"
      <*> o .: "whitelist_teams"
      <*> o .: "whitelist_usernames"

instance ToJSON CreateTagProtectionOption where
  toJSON = genericToJSON runOptions

data CreateTagProtectionOptionPayload = CreateTagProtectionOptionPayload
  { arpAction :: Text
  , arpRun :: CreateTagProtectionOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateTagProtectionOptionPayload where
  parseJSON = withObject "CreateTagProtectionOptionPayload" $ \o ->
    CreateTagProtectionOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateTagProtectionOptionPayload where
  toJSON = genericToJSON arpOptions
