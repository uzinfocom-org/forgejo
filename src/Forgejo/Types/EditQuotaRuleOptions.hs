{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditQuotaRuleOptions
  ( EditQuotaRuleOptions (..)
  , EditQuotaRuleOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditQuotaRuleOptions = EditQuotaRuleOptions
  { limit :: Int
  , subjects :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditQuotaRuleOptions where
  parseJSON = withObject "EditQuotaRuleOptions" $ \o ->
    EditQuotaRuleOptions
      <$> o .: "limit"
      <*> o .: "subjects"

instance ToJSON EditQuotaRuleOptions where
  toJSON = genericToJSON runOptions

data EditQuotaRuleOptionsPayload = EditQuotaRuleOptionsPayload
  { arpAction :: Text
  , arpRun :: EditQuotaRuleOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditQuotaRuleOptionsPayload where
  parseJSON = withObject "EditQuotaRuleOptionsPayload" $ \o ->
    EditQuotaRuleOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditQuotaRuleOptionsPayload where
  toJSON = genericToJSON arpOptions
