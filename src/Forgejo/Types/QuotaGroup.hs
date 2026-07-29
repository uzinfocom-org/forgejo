{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaGroup
  ( QuotaGroup (..)
  , QuotaGroupPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.QuotaRuleInfo (QuotaRuleInfo)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaGroup = QuotaGroup
  { name :: Text
  , rules :: [QuotaRuleInfo]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaGroup where
  parseJSON = withObject "QuotaGroup" $ \o ->
    QuotaGroup
      <$> o .: "name"
      <*> o .: "rules"

instance ToJSON QuotaGroup where
  toJSON = genericToJSON runOptions

data QuotaGroupPayload = QuotaGroupPayload
  { arpAction :: Text
  , arpRun :: QuotaGroup
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaGroupPayload where
  parseJSON = withObject "QuotaGroupPayload" $ \o ->
    QuotaGroupPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaGroupPayload where
  toJSON = genericToJSON arpOptions
