{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateQuotaGroupOptions
  ( CreateQuotaGroupOptions (..)
  , CreateQuotaGroupOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.CreateQuotaRuleOptions (CreateQuotaRuleOptions)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateQuotaGroupOptions = CreateQuotaGroupOptions
  { name :: Text
  , rules :: [CreateQuotaRuleOptions]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateQuotaGroupOptions where
  parseJSON = withObject "CreateQuotaGroupOptions" $ \o ->
    CreateQuotaGroupOptions
      <$> o .: "name"
      <*> o .: "rules"

instance ToJSON CreateQuotaGroupOptions where
  toJSON = genericToJSON runOptions

data CreateQuotaGroupOptionsPayload = CreateQuotaGroupOptionsPayload
  { arpAction :: Text
  , arpRun :: CreateQuotaGroupOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateQuotaGroupOptionsPayload where
  parseJSON = withObject "CreateQuotaGroupOptionsPayload" $ \o ->
    CreateQuotaGroupOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateQuotaGroupOptionsPayload where
  toJSON = genericToJSON arpOptions
