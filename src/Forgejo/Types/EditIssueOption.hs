{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditIssueOption
  ( EditIssueOption (..)
  , EditIssueOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.!=), (.:), (.:?))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditIssueOption = EditIssueOption
  { assignee :: Text
  , assignees :: [Text]
  , body :: Text
  , dueDate :: UTCTime
  , milestone :: Int
  , ref :: Text
  , state :: Text
  , title :: Text
  , unsetDueDate :: Bool
  , updatedAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditIssueOption where
  parseJSON = withObject "EditIssueOption" $ \o ->
    EditIssueOption
      <$> o .: "assignee"
      <*> (o .:? "assignees" .!= [])
      <*> o .: "body"
      <*> o .: "due_date"
      <*> o .: "milestone"
      <*> o .: "ref"
      <*> o .: "state"
      <*> o .: "title"
      <*> o .: "unset_due_date"
      <*> o .: "updated_at"

instance ToJSON EditIssueOption where
  toJSON = genericToJSON runOptions

data EditIssueOptionPayload = EditIssueOptionPayload
  { arpAction :: Text
  , arpRun :: EditIssueOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditIssueOptionPayload where
  parseJSON = withObject "EditIssueOptionPayload" $ \o ->
    EditIssueOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditIssueOptionPayload where
  toJSON = genericToJSON arpOptions
