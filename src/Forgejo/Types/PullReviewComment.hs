{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PullReviewComment
  ( PullReviewComment (..)
  , PullReviewCommentPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PullReviewComment = PullReviewComment
  { body :: Text
  , commitId :: Text
  , createdAt :: UTCTime
  , diffHunk :: Text
  , htmlUrl :: Text
  , id :: Int
  , originalCommitId :: Text
  , originalPosition :: Int
  , path :: Text
  , position :: Int
  , pullRequestReviewId :: Int
  , pullRequestUrl :: Text
  , resolver :: User
  , updatedAt :: UTCTime
  , user :: User
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PullReviewComment where
  parseJSON = withObject "PullReviewComment" $ \o ->
    PullReviewComment
      <$> o .: "user"
      <*> o .: "commit_id"
      <*> o .: "created_at"
      <*> o .: "diff_hunk"
      <*> o .: "html_url"
      <*> o .: "id"
      <*> o .: "original_commit_id"
      <*> o .: "original_position"
      <*> o .: "path"
      <*> o .: "position"
      <*> o .: "pull_request_review_id"
      <*> o .: "pull_request_url"
      <*> o .: "resolver"
      <*> o .: "updated_at"
      <*> o .: "user"

instance ToJSON PullReviewComment where
  toJSON = genericToJSON runOptions

data PullReviewCommentPayload = PullReviewCommentPayload
  { arpAction :: Text
  , arpRun :: PullReviewComment
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PullReviewCommentPayload where
  parseJSON = withObject "PullReviewCommentPayload" $ \o ->
    PullReviewCommentPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PullReviewCommentPayload where
  toJSON = genericToJSON arpOptions
