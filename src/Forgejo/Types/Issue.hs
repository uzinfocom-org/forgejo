module Forgejo.Types.Issue
  ( Issue (..)
  , IssuePRRef (..)
  , IssueRepository (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value, genericParseJSON, genericToJSON)
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

-- Minimal PR reference embedded inside an Issue object
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

-- Minimal repository reference embedded inside an Issue object
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

data Issue = Issue
  { issueId :: IssueId
  , issueUrl :: Text
  , issueHtmlUrl :: Text
  , issueNumber :: Int
  , issueUser :: User
  , issueOriginalAuthor :: Text
  , issueOriginalAuthorId :: UserId
  , issueTitle :: Text
  , issueBody :: Text
  , issueRef :: Text
  , issueAssets :: [Attachment]
  , issueLabels :: [Label]
  , issueMilestone :: Maybe Milestone
  , issueAssignee :: Maybe User
  , issueAssignees :: Maybe [User]
  , issueState :: Text
  , issueIsLocked :: Bool
  , issueComments :: Int
  , issueCreatedAt :: UTCTime
  , issueUpdatedAt :: UTCTime
  , issueClosedAt :: Maybe UTCTime
  , issueDueDate :: Maybe UTCTime
  , issuePullRequest :: Maybe IssuePRRef
  , issueRepository :: IssueRepository
  , issuePinOrder :: Int
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Issue where
  parseJSON = genericParseJSON issueOptions
