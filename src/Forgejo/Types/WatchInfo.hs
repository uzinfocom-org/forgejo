{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.WatchInfo
  ( WatchInfo (..)
  , WatchInfoPayload (..)
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

data WatchInfo = WatchInfo
  { createdAt :: UTCTime
  , ignored :: Bool
  , reason :: ()
  , -- FIXME: original - {}
    repositoryUrl :: Text
  , subscribed :: Bool
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON WatchInfo where
  parseJSON = withObject "WatchInfo" $ \o ->
    WatchInfo
      <$> o .: "created_at"
      <*> o .: "ignored"
      <*> o .: "reason"
      <*> o .: "repository_url"
      <*> o .: "subscribed"
      <*> o .: "url"

instance ToJSON WatchInfo where
  toJSON = genericToJSON runOptions

data WatchInfoPayload = WatchInfoPayload
  { arpAction :: Text
  , arpRun :: WatchInfo
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON WatchInfoPayload where
  parseJSON = withObject "WatchInfoPayload" $ \o ->
    WatchInfoPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON WatchInfoPayload where
  toJSON = genericToJSON arpOptions
