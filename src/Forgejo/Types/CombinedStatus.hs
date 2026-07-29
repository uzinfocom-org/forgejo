{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CombinedStatus
  ( CombinedStatus (..)
  , CombinedStatusPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.CommitStatus (CommitStatus, CommitStatusState)
import Forgejo.Types.Repository (Repository)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CombinedStatus = CombinedStatus
  { commitUrl :: Text
  , repository :: Repository
  , sha :: Text
  , state :: CommitStatusState
  , statuses :: [CommitStatus]
  , totalCount :: Int
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CombinedStatus where
  parseJSON = withObject "CombinedStatus" $ \o ->
    CombinedStatus
      <$> o .: "commit_url"
      <*> o .: "repository"
      <*> o .: "sha"
      <*> o .: "state"
      <*> o .: "statuses"
      <*> o .: "total_count"
      <*> o .: "url"

instance ToJSON CombinedStatus where
  toJSON = genericToJSON runOptions

data CombinedStatusPayload = CombinedStatusPayload
  { arpAction :: Text
  , arpRun :: CombinedStatus
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CombinedStatusPayload where
  parseJSON = withObject "CombinedStatusPayload" $ \o ->
    CombinedStatusPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CombinedStatusPayload where
  toJSON = genericToJSON arpOptions
