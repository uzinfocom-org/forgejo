{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.UserHeatmapData
  ( UserHeatmapData (..)
  , UserHeatmapDataPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data UserHeatmapData = UserHeatmapData
  { contributions :: Int
  , timestamp :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON UserHeatmapData where
  parseJSON = withObject "UserHeatmapData" $ \o ->
    UserHeatmapData
      <$> o .: "contributions"
      <*> o .: "timestamp"

instance ToJSON UserHeatmapData where
  toJSON = genericToJSON runOptions

data UserHeatmapDataPayload = UserHeatmapDataPayload
  { arpAction :: Text
  , arpRun :: UserHeatmapData
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON UserHeatmapDataPayload where
  parseJSON = withObject "UserHeatmapDataPayload" $ \o ->
    UserHeatmapDataPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON UserHeatmapDataPayload where
  toJSON = genericToJSON arpOptions
