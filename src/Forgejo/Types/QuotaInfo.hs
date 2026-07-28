{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaInfo
  ( QuotaInfo (..)
  , QuotaInfoPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.QuotaGroup (QuotaGroup)
import Forgejo.Types.QuotaUsed (QuotaUsed)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaInfo = QuotaInfo
  { groups :: [QuotaGroup]
  , used :: QuotaUsed
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaInfo where
  parseJSON = withObject "QuotaInfo" $ \o ->
    QuotaInfo
      <$> o .: "groups"
      <*> o .: "used"

instance ToJSON QuotaInfo where
  toJSON = genericToJSON runOptions

data QuotaInfoPayload = QuotaInfoPayload
  { arpAction :: Text
  , arpRun :: QuotaInfo
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaInfoPayload where
  parseJSON = withObject "QuotaInfoPayload" $ \o ->
    QuotaInfoPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaInfoPayload where
  toJSON = genericToJSON arpOptions
