{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditPullRequestOption
  ( EditPullRequestOption (..)
  , EditPullRequestOptionPayload (..)
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

data EditPullRequestOption = EditPullRequestOption
  { allowMaintainerEdit :: Bool
  , assignee :: Text
  , assignees :: [Text]
  , base :: Text
  , body :: Text
  , dueDate :: UTCTime
  , labels :: [Int]
  , milestone :: Int
  , state :: Text
  , title :: Text
  , unsetDueDate :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditPullRequestOption where
  parseJSON = withObject "EditPullRequestOption" $ \o ->
    EditPullRequestOption
      <$> o .: "allow_maintainer_edit"
      <*> o .: "assignee"
      <*> o .: "assignees"
      <*> o .: "base"
      <*> o .: "body"
      <*> o .: "due_date"
      <*> o .: "labels"
      <*> o .: "milestone"
      <*> o .: "state"
      <*> o .: "title"
      <*> o .: "unset_due_date"

instance ToJSON EditPullRequestOption where
  toJSON = genericToJSON runOptions

data EditPullRequestOptionPayload = EditPullRequestOptionPayload
  { arpAction :: Text
  , arpRun :: EditPullRequestOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditPullRequestOptionPayload where
  parseJSON = withObject "EditPullRequestOptionPayload" $ \o ->
    EditPullRequestOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditPullRequestOptionPayload where
  toJSON = genericToJSON arpOptions
