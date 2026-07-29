{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.SetUserQuotaGroupsOptions
  ( SetUserQuotaGroupsOptions (..)
  , SetUserQuotaGroupsOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data SetUserQuotaGroupsOptions = SetUserQuotaGroupsOptions
  { groups :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON SetUserQuotaGroupsOptions where
  parseJSON = withObject "SetUserQuotaGroupsOptions" $ \o ->
    SetUserQuotaGroupsOptions
      <$> o .: "groups"

instance ToJSON SetUserQuotaGroupsOptions where
  toJSON = genericToJSON runOptions

data SetUserQuotaGroupsOptionsPayload = SetUserQuotaGroupsOptionsPayload
  { arpAction :: Text
  , arpRun :: SetUserQuotaGroupsOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON SetUserQuotaGroupsOptionsPayload where
  parseJSON = withObject "SetUserQuotaGroupsOptionsPayload" $ \o ->
    SetUserQuotaGroupsOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON SetUserQuotaGroupsOptionsPayload where
  toJSON = genericToJSON arpOptions
