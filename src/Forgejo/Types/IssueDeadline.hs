{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.IssueDeadline
  ( IssueDeadline (..)
  , IssueDeadlinePayload (..)
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

data IssueDeadline = IssueDeadline
  { dueDate :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON IssueDeadline where
  parseJSON = withObject "IssueDeadline" $ \o ->
    IssueDeadline
      <$> o .: "due_date"

instance ToJSON IssueDeadline where
  toJSON = genericToJSON runOptions

data IssueDeadlinePayload = IssueDeadlinePayload
  { arpAction :: Text
  , arpRun :: IssueDeadline
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IssueDeadlinePayload where
  parseJSON = withObject "IssueDeadlinePayload" $ \o ->
    IssueDeadlinePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON IssueDeadlinePayload where
  toJSON = genericToJSON arpOptions
