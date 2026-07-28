{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PullReview
  ( PullReview (..)
  , PullReviewPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Team (Team)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PullReview = PullReview
  { body :: Text
  , commentsCount :: Int
  , commitId :: Text
  , dismissed :: Bool
  , htmlUrl :: Text
  , id :: Int
  , official :: Bool
  , pullRequestUrl :: Text
  , stale :: Bool
  , state :: Text
  , submittedAt :: UTCTime
  , team :: Team
  , updatedAt :: UTCTime
  , user :: User
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PullReview where
  parseJSON = withObject "PullReview" $ \o ->
    PullReview
      <$> o .: "body"
      <*> o .: "comments_count"
      <*> o .: "commit_id"
      <*> o .: "dismissed"
      <*> o .: "html_url"
      <*> o .: "id"
      <*> o .: "official"
      <*> o .: "pull_request_url"
      <*> o .: "stale"
      <*> o .: "state"
      <*> o .: "submitted_at"
      <*> o .: "team"
      <*> o .: "updated_at"
      <*> o .: "user"

instance ToJSON PullReview where
  toJSON = genericToJSON runOptions

data PullReviewPayload = PullReviewPayload
  { arpAction :: Text
  , arpRun :: PullReview
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PullReviewPayload where
  parseJSON = withObject "PullReviewPayload" $ \o ->
    PullReviewPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PullReviewPayload where
  toJSON = genericToJSON arpOptions
