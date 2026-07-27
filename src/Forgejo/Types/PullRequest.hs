module Forgejo.Types.PullRequest
  ( PRBranch (..)
  , PullRequest (..)
  , PullRequestPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value, genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Common (PullRequestId, RepoId)
import Forgejo.Types.Repository (Repository)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

branchOptions :: Options
branchOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 6}

prOptions :: Options
prOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

prpOptions :: Options
prpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PRBranch = PRBranch
  { branchLabel :: Text
  , branchRef :: Text
  , branchSha :: Text
  , branchRepoId :: RepoId
  , branchRepo :: Repository
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PRBranch where
  parseJSON = genericParseJSON branchOptions

instance ToJSON PRBranch where
  toJSON = genericToJSON branchOptions

data PullRequest = PullRequest
  { prId :: PullRequestId
  , prUrl :: Text
  , prNumber :: Int
  , prUser :: User
  , prTitle :: Text
  , prBody :: Text
  , prLabels :: [Value]
  , prMilestone :: Maybe Value
  , prAssignee :: Maybe Value
  , prAssignees :: Maybe [Value]
  , prRequestedReviewers :: [Value]
  , prRequestedReviewersTeams :: [Value]
  , prState :: Text
  , prDraft :: Bool
  , prIsLocked :: Bool
  , prComments :: Int
  , prReviewComments :: Int
  , prAdditions :: Int
  , prDeletions :: Int
  , prChangedFiles :: Int
  , prHtmlUrl :: Text
  , prDiffUrl :: Text
  , prPatchUrl :: Text
  , prMergeable :: Bool
  , prMerged :: Bool
  , prMergedAt :: Maybe UTCTime
  , prMergeCommitSha :: Maybe Text
  , prMergedBy :: Maybe User
  , prAllowMaintainerEdit :: Bool
  , prBase :: PRBranch
  , prHead :: PRBranch
  , prMergeBase :: Text
  , prDueDate :: Maybe UTCTime
  , prCreatedAt :: UTCTime
  , prUpdatedAt :: UTCTime
  , prClosedAt :: Maybe UTCTime
  , prPinOrder :: Int
  , prFlow :: Int
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PullRequest where
  parseJSON = genericParseJSON prOptions

instance ToJSON PullRequest where
  toJSON = genericToJSON prOptions

data PullRequestPayload = PullRequestPayload
  { prpAction :: Text
  , prpNumber :: Int
  , prpPullRequest :: PullRequest
  , prpRequestedReviewer :: Maybe User
  , prpRepository :: Repository
  , prpSender :: User
  , prpCommitId :: Text
  , prpReview :: Maybe Value
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PullRequestPayload where
  parseJSON = genericParseJSON prpOptions

instance ToJSON PullRequestPayload where
  toJSON = genericToJSON prpOptions
