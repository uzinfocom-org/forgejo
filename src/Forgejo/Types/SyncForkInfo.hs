{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.SyncForkInfo
  ( SyncForkInfo (..)
  , SyncForkInfoPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data SyncForkInfo = SyncForkInfo
  { allowed :: Bool
  , baseCommit :: Text
  , commitsBehind :: Int
  , forkCommit :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON SyncForkInfo where
  parseJSON = withObject "SyncForkInfo" $ \o ->
    SyncForkInfo
      <$> o .: "allowed"
      <*> o .: "base_commit"
      <*> o .: "commits_behind"
      <*> o .: "fork_commit"

instance ToJSON SyncForkInfo where
  toJSON = genericToJSON runOptions

data SyncForkInfoPayload = SyncForkInfoPayload
  { arpAction :: Text
  , arpRun :: SyncForkInfo
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON SyncForkInfoPayload where
  parseJSON = withObject "SyncForkInfoPayload" $ \o ->
    SyncForkInfoPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON SyncForkInfoPayload where
  toJSON = genericToJSON arpOptions
