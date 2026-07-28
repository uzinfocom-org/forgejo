{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.TimelineComment
  ( TimelineComment (..)
  , TimelineCommentPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Comment (Comment)
import Forgejo.Types.Label (Label)
import Forgejo.Types.Milestone (Milestone)
import Forgejo.Types.Team (Team)
import Forgejo.Types.TrackedTime (TrackedTime)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data TimelineComment = TimelineComment
  { assignee :: User
  , assigneeTeam :: Team
  , body :: Text
  , createdAt :: UTCTime
  , htmlUrl :: Text
  , id :: Int
  , issueUrl :: Text
  , label :: Label
  , milestone :: Milestone
  , newRef :: Text
  , newTitle :: Text
  , oldMilestone :: Milestone
  , oldProjectId :: Int
  , oldRef :: Text
  , oldTitle :: Text
  , projectId :: Int
  , pullRequestUrl :: Text
  , refAction :: Text
  , refComment :: Comment
  , refCommitSha :: Text
  , removedAssignee :: Bool
  , resolveDoer :: User
  , reviewId :: Int
  , trackedTime :: TrackedTime
  , tcType :: Text
  , updatedAt :: UTCTime
  , user :: User
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON TimelineComment where
  parseJSON = withObject "TimelineComment" $ \o ->
    TimelineComment
      <$> o .: "assignee"
      <*> o .: "assignee_team"
      <*> o .: "body"
      <*> o .: "created_at"
      <*> o .: "html_url"
      <*> o .: "id"
      <*> o .: "issue_url"
      <*> o .: "label"
      <*> o .: "milestone"
      <*> o .: "new_ref"
      <*> o .: "new_title"
      <*> o .: "old_milestone"
      <*> o .: "old_project_id"
      <*> o .: "old_ref"
      <*> o .: "old_title"
      <*> o .: "project_id"
      <*> o .: "pull_request_url"
      <*> o .: "ref_action"
      <*> o .: "ref_comment"
      <*> o .: "ref_commit_sha"
      <*> o .: "removed_assignee"
      <*> o .: "resolve_doer"
      <*> o .: "review_id"
      <*> o .: "tracked_time"
      <*> o .: "type"
      <*> o .: "updated_at"
      <*> o .: "user"

instance ToJSON TimelineComment where
  toJSON = genericToJSON runOptions

data TimelineCommentPayload = TimelineCommentPayload
  { arpAction :: Text
  , arpRun :: TimelineComment
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON TimelineCommentPayload where
  parseJSON = withObject "TimelineCommentPayload" $ \o ->
    TimelineCommentPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON TimelineCommentPayload where
  toJSON = genericToJSON arpOptions
