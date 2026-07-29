{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CommitDateOptions
  ( CommitDateOptions (..)
  , CommitDateOptionsPayload (..)
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

data CommitDateOptions = CommitDateOptions
  { author :: UTCTime
  , committer :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CommitDateOptions where
  parseJSON = withObject "CommitDateOptions" $ \o ->
    CommitDateOptions
      <$> o .: "author"
      <*> o .: "committer"

instance ToJSON CommitDateOptions where
  toJSON = genericToJSON runOptions

data CommitDateOptionsPayload = CommitDateOptionsPayload
  { arpAction :: Text
  , arpRun :: CommitDateOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CommitDateOptionsPayload where
  parseJSON = withObject "CommitDateOptionsPayload" $ \o ->
    CommitDateOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CommitDateOptionsPayload where
  toJSON = genericToJSON arpOptions
