{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Milestone
  ( Milestone (..)
  , MilestonePayload (..)
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

data Milestone = Milestone
  { closedAt :: UTCTime
  , closedIssues :: Int
  , createdAt :: UTCTime
  , description :: Text
  , dueOn :: Text
  , id :: Int
  , openIssues :: Int
  , state :: Text
  , title :: Text
  , updatedAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Milestone where
  parseJSON = withObject "Milestone" $ \o ->
    Milestone
      <$> o .: "closed_at"
      <*> o .: "closed_issues"
      <*> o .: "created_at"
      <*> o .: "description"
      <*> o .: "due_on"
      <*> o .: "id"
      <*> o .: "open_issues"
      <*> o .: "state"
      <*> o .: "title"
      <*> o .: "updated_at"

instance ToJSON Milestone where
  toJSON = genericToJSON runOptions

data MilestonePayload = MilestonePayload
  { arpAction :: Text
  , arpRun :: Milestone
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON MilestonePayload where
  parseJSON = withObject "MilestonePayload" $ \o ->
    MilestonePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON MilestonePayload where
  toJSON = genericToJSON arpOptions
