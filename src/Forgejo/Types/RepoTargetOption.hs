{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RepoTargetOption
  ( RepoTargetOption (..)
  , RepoTargetOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RepoTargetOption = RepoTargetOption
  { name :: Text
  , owner :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RepoTargetOption where
  parseJSON = withObject "RepoTargetOption" $ \o ->
    RepoTargetOption
      <$> o .: "block_id"
      <*> o .: "created_at"

instance ToJSON RepoTargetOption where
  toJSON = genericToJSON runOptions

data RepoTargetOptionPayload = RepoTargetOptionPayload
  { arpAction :: Text
  , arpRun :: RepoTargetOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RepoTargetOptionPayload where
  parseJSON = withObject "RepoTargetOptionPayload" $ \o ->
    RepoTargetOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RepoTargetOptionPayload where
  toJSON = genericToJSON arpOptions
