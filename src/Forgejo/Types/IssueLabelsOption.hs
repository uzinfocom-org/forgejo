{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.IssueLabelsOption
  ( IssueLabelsOption (..)
  , IssueLabelsOptionPayload (..)
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

data IssueLabelsOption = IssueLabelsOption
  { labels :: [Text] -- Labels can be a list of integers representing label IDs or a list of strings representing label names
  , updatedAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON IssueLabelsOption where
  parseJSON = withObject "IssueLabelsOption" $ \o ->
    IssueLabelsOption
      <$> o .: "labels"
      <*> o .: "updated_at"

instance ToJSON IssueLabelsOption where
  toJSON = genericToJSON runOptions

data IssueLabelsOptionPayload = IssueLabelsOptionPayload
  { arpAction :: Text
  , arpRun :: IssueLabelsOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IssueLabelsOptionPayload where
  parseJSON = withObject "IssueLabelsOptionPayload" $ \o ->
    IssueLabelsOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON IssueLabelsOptionPayload where
  toJSON = genericToJSON arpOptions
