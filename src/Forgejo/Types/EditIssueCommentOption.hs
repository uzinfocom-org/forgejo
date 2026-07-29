{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditIssueCommentOption
  ( EditIssueCommentOption (..)
  , EditIssueCommentOptionPayload (..)
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

data EditIssueCommentOption = EditIssueCommentOption
  { body :: Text
  , updatedAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditIssueCommentOption where
  parseJSON = withObject "EditIssueCommentOption" $ \o ->
    EditIssueCommentOption
      <$> o .: "body"
      <*> o .: "updated_at"

instance ToJSON EditIssueCommentOption where
  toJSON = genericToJSON runOptions

data EditIssueCommentOptionPayload = EditIssueCommentOptionPayload
  { arpAction :: Text
  , arpRun :: EditIssueCommentOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditIssueCommentOptionPayload where
  parseJSON = withObject "EditIssueCommentOption" $ \o ->
    EditIssueCommentOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditIssueCommentOptionPayload where
  toJSON = genericToJSON arpOptions
