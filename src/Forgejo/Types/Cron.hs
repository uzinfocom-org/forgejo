{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Cron
  ( Cron (..)
  , CronPayload (..)
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

data Cron = Cron
  { execTimes :: Int
  , name :: Text
  , next :: UTCTime
  , prev :: UTCTime
  , schedule :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Cron where
  parseJSON = withObject "Cron" $ \o ->
    Cron
      <$> o .: "exec_times"
      <*> o .: "name"
      <*> o .: "next"
      <*> o .: "prev"
      <*> o .: "schedule"

instance ToJSON Cron where
  toJSON = genericToJSON runOptions

data CronPayload = CronPayload
  { arpAction :: Text
  , arpRun :: Cron
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CronPayload where
  parseJSON = withObject "CronPayload" $ \o ->
    CronPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CronPayload where
  toJSON = genericToJSON arpOptions
