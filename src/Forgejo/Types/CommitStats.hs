{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CommitStats
  ( CommitStats (..)
  , CommitStatsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CommitStats = CommitStats
  { additions :: Int
  , deletions :: Int
  , total :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CommitStats where
  parseJSON = withObject "CommitStats" $ \o ->
    CommitStats
      <$> o .: "additions"
      <*> o .: "deletions"
      <*> o .: "total"

instance ToJSON CommitStats where
  toJSON = genericToJSON runOptions

data CommitStatsPayload = CommitStatsPayload
  { arpAction :: Text
  , arpRun :: CommitStats
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CommitStatsPayload where
  parseJSON = withObject "CommitStatsPayload" $ \o ->
    CommitStatsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CommitStatsPayload where
  toJSON = genericToJSON arpOptions
