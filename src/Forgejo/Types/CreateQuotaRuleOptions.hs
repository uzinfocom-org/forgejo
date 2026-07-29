{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateQuotaRuleOptions
  ( CreateQuotaRuleOptions (..)
  , CreateQuotaRuleOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateQuotaRuleOptions = CreateQuotaRuleOptions
  { limit :: Int
  , name :: Text
  , subjects :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateQuotaRuleOptions where
  parseJSON = withObject "CreateQuotaRuleOptions" $ \o ->
    CreateQuotaRuleOptions
      <$> o .: "limit"
      <*> o .: "name"
      <*> o .: "subjects"

instance ToJSON CreateQuotaRuleOptions where
  toJSON = genericToJSON runOptions

data CreateQuotaRuleOptionsPayload = CreateQuotaRuleOptionsPayload
  { arpAction :: Text
  , arpRun :: CreateQuotaRuleOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateQuotaRuleOptionsPayload where
  parseJSON = withObject "CreateQuotaRuleOptionsPayload" $ \o ->
    CreateQuotaRuleOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateQuotaRuleOptionsPayload where
  toJSON = genericToJSON arpOptions
