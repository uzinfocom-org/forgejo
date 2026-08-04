{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.TrackedTime
  ( TrackedTime (..)
  , TrackedTimePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Issue (Issue)
import GHC.Generics (Generic)

data TrackedTime = TrackedTime
  { created :: UTCTime
  , id :: Int
  , issue :: Issue
  , time :: Int
  , userName :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON TrackedTime where
  parseJSON = withObject "TrackedTime" $ \o ->
    TrackedTime
      <$> o .: "created"
      <*> o .: "id"
      <*> o .: "repo_count"
      <*> o .: "topic_name"
      <*> o .: "updated"

data TrackedTimePayload = TrackedTimePayload
  { arpAction :: Text
  , arpRun :: TrackedTime
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON TrackedTimePayload where
  parseJSON = withObject "TrackedTimePayload" $ \o ->
    TrackedTimePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"
