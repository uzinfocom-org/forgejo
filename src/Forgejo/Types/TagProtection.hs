{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.TagProtection
  ( TagProtection (..)
  , TagProtectionPayload (..)
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

data TagProtection = TagProtection
  { createdAt :: UTCTime
  , id :: Int
  , namePattern :: Text
  , updatedAt :: UTCTime
  , whitelistTeams :: [Text]
  , whitelistUsernames :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON TagProtection where
  parseJSON = withObject "TagProtection" $ \o ->
    TagProtection
      <$> o .: "created_at"
      <*> o .: "id"
      <*> o .: "name_pattern"
      <*> o .: "updated_at"
      <*> o .: "whitelist_teams"
      <*> o .: "whitelist_usernames"

instance ToJSON TagProtection where
  toJSON = genericToJSON runOptions

data TagProtectionPayload = TagProtectionPayload
  { arpAction :: Text
  , arpRun :: TagProtection
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON TagProtectionPayload where
  parseJSON = withObject "TagProtectionPayload" $ \o ->
    TagProtectionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON TagProtectionPayload where
  toJSON = genericToJSON arpOptions
