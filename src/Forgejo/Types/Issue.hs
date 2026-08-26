{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Issue
  ( Issue (..)
  , IssuePRRef (..)
  , IssueRepository (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON, withObject, (.!=), (.:), (.:?))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Attachment (Attachment)
import Forgejo.Types.Common (IssueId, RepoId, UserId)
import Forgejo.Types.Label (Label)
import Forgejo.Types.Milestone (Milestone)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

issueOptions :: Options
issueOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 5}

issuePROptions :: Options
issuePROptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 7}

issueRepoOptions :: Options
issueRepoOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 9}

-- | Minimal PR reference embedded inside an Issue object
data IssuePRRef = IssuePRRef
  { issuePRMerged :: Bool
  , issuePRMergedAt :: Maybe UTCTime
  , issuePRDraft :: Bool
  , issuePRHtmlUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IssuePRRef where
  parseJSON = genericParseJSON issuePROptions

instance ToJSON IssuePRRef where
  toJSON = genericToJSON issuePROptions

-- | Minimal repository reference embedded inside an Issue object
data IssueRepository = IssueRepository
  { issueRepoId :: RepoId
  , issueRepoName :: Text
  , issueRepoOwner :: Text
  , issueRepoFullName :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IssueRepository where
  parseJSON = genericParseJSON issueRepoOptions

instance ToJSON IssueRepository where
  toJSON = genericToJSON issueRepoOptions

-- | This type is used for the body of issues from Forgejo
data Issue = Issue
  { issueId :: IssueId
  -- ^ id of 'Issue'
  , issueUrl :: Text
  -- ^ REST API url of 'Issue'
  , issueHtmlUrl :: Text
  -- ^ Clickable HTML URL of 'Issue'
  , issueNumber :: Int
  -- ^ Number of 'Issue' in 'Repository'
  , issueUser :: User
  -- ^ Author/user ('User') of 'Issue'
  , issueOriginalAuthor :: Text
  -- ^ Original author of 'Issue' if it's changed
  , issueOriginalAuthorId :: UserId
  -- ^ Id of original author of 'Issue' if it's changed
  , issueTitle :: Text
  -- ^ Title of 'Issue'
  , issueBody :: Text
  -- ^ Body of 'Issue'
  , issueRef :: Text
  -- ^ References of 'Issue'
  , issueAssets :: [Attachment]
  -- ^ Assets of 'Issue'
  , issueLabels :: [Label]
  -- ^ Labels of 'Issue'
  , issueMilestone :: Maybe Milestone
  -- ^ Milestone of 'Issue'
  , issueAssignee :: Maybe User
  -- ^ Assignee of 'Issue'
  , issueAssignees :: [User]
  -- ^ Assignees of 'Issue'
  , issueState :: Text
  -- ^ State of 'Issue'
  , issueIsLocked :: Bool
  -- ^ Information about lock of 'Issue'
  , issueComments :: Int
  -- ^ Amount of comments of 'Issue'
  , issueCreatedAt :: UTCTime
  -- ^ Created time of 'Issue'
  , issueUpdatedAt :: UTCTime
  -- ^ Last updated time of 'Issue'
  , issueClosedAt :: Maybe UTCTime
  -- ^ Closed time of 'Issue'
  , issueDueDate :: Maybe UTCTime
  -- ^ Deadline of 'Issue'
  , issuePullRequest :: Maybe IssuePRRef
  -- ^ 'PullRequest' reference of 'Issue'
  , issueRepository :: IssueRepository
  -- ^ 'Repository' of 'Issue'
  , issuePinOrder :: Int
  -- ^ Pin order of 'Issue'
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Issue where
  parseJSON = withObject "Issue" $ \o ->
    Issue
      <$> o .: "id"
      <*> o .: "url"
      <*> o .: "html_url"
      <*> o .: "number"
      <*> o .: "user"
      <*> o .: "original_author"
      <*> o .: "original_author_id"
      <*> o .: "title"
      <*> o .: "body"
      <*> o .: "ref"
      <*> (o .:? "assets" .!= [])
      <*> (o .:? "labels" .!= [])
      <*> o .:? "milestone"
      <*> o .:? "assignee"
      <*> (o .:? "assignees" .!= [])
      <*> o .: "state"
      <*> o .: "is_locked"
      <*> o .: "comments"
      <*> o .: "created_at"
      <*> o .: "updated_at"
      <*> o .:? "closed_at"
      <*> o .:? "due_date"
      <*> o .:? "pull_request"
      <*> o .: "repository"
      <*> o .: "pin_order"

instance ToJSON Issue where
  toJSON = genericToJSON issueOptions
