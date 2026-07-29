{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaRuleInfo
  ( QuotaRuleInfo (..)
  , QuotaRuleInfoPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaRuleInfo = QuotaRuleInfo
  { limit :: Int
  , name :: Text
  , subjects :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaRuleInfo where
  parseJSON = withObject "QuotaRuleInfo" $ \o ->
    QuotaRuleInfo
      <$> o .: "limit"
      <*> o .: "name"
      <*> o .: "subjects"

instance ToJSON QuotaRuleInfo where
  toJSON = genericToJSON runOptions

data QuotaRuleInfoPayload = QuotaRuleInfoPayload
  { arpAction :: Text
  , arpRun :: QuotaRuleInfo
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaRuleInfoPayload where
  parseJSON = withObject "QuotaRuleInfoPayload" $ \o ->
    QuotaRuleInfoPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaRuleInfoPayload where
  toJSON = genericToJSON arpOptions
