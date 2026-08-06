{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.TimelineComment
  ( TimelineComment (..)
  ) where

import Data.Aeson (FromJSON, parseJSON, withObject, (.:))
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Comment (Comment)
import Forgejo.Types.Label (Label)
import Forgejo.Types.Milestone (Milestone)
import Forgejo.Types.Team (Team)
import Forgejo.Types.TrackedTime (TrackedTime)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

data TimelineComment = TimelineComment
  { tcAssignee :: User
  , tcAssigneeTeam :: Team
  , tcBody :: Text
  , tcCreatedAt :: UTCTime
  , tcHtmlUrl :: Text
  , tcId :: Int
  , tcIssueUrl :: Text
  , tcLabel :: Label
  , tcMilestone :: Milestone
  , tcNewRef :: Text
  , tcNewTitle :: Text
  , tcOldMilestone :: Milestone
  , tcOldProjectId :: Int
  , tcOldRef :: Text
  , tcOldTitle :: Text
  , tcProjectId :: Int
  , tcPullRequestUrl :: Text
  , tcRefAction :: Text
  , tcRefComment :: Comment
  , tcRefCommitSha :: Text
  , tcRemovedAssignee :: Bool
  , tcResolveDoer :: User
  , tcVeviewId :: Int
  , tcTrackedTime :: TrackedTime
  , tcType :: Text
  , tcUpdatedAt :: UTCTime
  , tcUser :: User
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
