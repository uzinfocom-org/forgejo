{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreatePullRequestOption
  ( CreatePullRequestOption (..)
  , CreatePullRequestOptionPayload (..)
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

data CreatePullRequestOption = CreatePullRequestOption
  { assignee :: Text
  , assignees :: [Text]
  , base :: Text
  , body :: Text
  , dueDate :: UTCTime
  , head :: Text
  , labels :: [Int]
  , milestone :: Int
  , title :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreatePullRequestOption where
  parseJSON = withObject "CreatePullRequestOption" $ \o ->
    CreatePullRequestOption
      <$> o .: "assignee"
      <*> o .: "assignees"
      <*> o .: "base"
      <*> o .: "body"
      <*> o .: "due_date"
      <*> o .: "head"
      <*> o .: "labels"
      <*> o .: "milestone"
      <*> o .: "title"

instance ToJSON CreatePullRequestOption where
  toJSON = genericToJSON runOptions

data CreatePullRequestOptionPayload = CreatePullRequestOptionPayload
  { arpAction :: Text
  , arpRun :: CreatePullRequestOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreatePullRequestOptionPayload where
  parseJSON = withObject "CreatePullRequestOptionPayload" $ \o ->
    CreatePullRequestOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreatePullRequestOptionPayload where
  toJSON = genericToJSON arpOptions
