{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateIssueCommentOption
  ( CreateIssueCommentOption (..)
  , CreateIssueCommentOptionPayload (..)
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

data CreateIssueCommentOption = CreateIssueCommentOption
  { body :: Text
  , updatedAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateIssueCommentOption where
  parseJSON = withObject "CreateIssueCommentOption" $ \o ->
    CreateIssueCommentOption
      <$> o .: "body"
      <*> o .: "updated_at"

instance ToJSON CreateIssueCommentOption where
  toJSON = genericToJSON runOptions

data CreateIssueCommentOptionPayload = CreateIssueCommentOptionPayload
  { arpAction :: Text
  , arpRun :: CreateIssueCommentOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateIssueCommentOptionPayload where
  parseJSON = withObject "CreateIssueCommentOptionPayload" $ \o ->
    CreateIssueCommentOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateIssueCommentOptionPayload where
  toJSON = genericToJSON arpOptions
