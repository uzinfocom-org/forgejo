{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PullRequest
  ( PRBranch (..)
  , PullRequest (..)
  , PullRequestPayload (..)
  , HookPullRequestAction (..)
  , ReviewPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value, genericParseJSON, genericToJSON)
import Data.Aeson qualified as AE
import Data.Aeson.Encoding qualified as AE
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Common (PullRequestId, RepoId)
import Forgejo.Types.Label (Label)
import Forgejo.Types.Repository (Repository)
import Forgejo.Types.Team (Team)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

branchOptions :: Options
branchOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 6}

prOptions :: Options
prOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

prpOptions :: Options
prpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

reviewOptions :: Options
reviewOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

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
  , prLabels :: [Label]
  , prMilestone :: Maybe Value
  , prAssignee :: Maybe User
  , prAssignees :: Maybe [User] -- Forgejo returns null instead of empty list. That's why we use Maybe
  , prRequestedReviewers :: [User]
  , prRequestedReviewersTeams :: [Team]
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

data ReviewPayload = ReviewPayload
  { rvType :: Text
  , rvContent :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ReviewPayload where
  parseJSON = genericParseJSON reviewOptions

instance ToJSON ReviewPayload where
  toJSON = genericToJSON reviewOptions

data PullRequestPayload = PullRequestPayload
  { prpAction :: HookPullRequestAction
  , prpNumber :: Int
  , prpPullRequest :: PullRequest
  , prpRequestedReviewer :: Maybe User
  , prpRepository :: Repository
  , prpSender :: User
  , prpCommitId :: Text
  , prpReview :: Maybe ReviewPayload
  }
  deriving stock (Eq, Generic, Show)

data HookPullRequestAction
  = PrOpened
  | PrClosed -- a merged PR is closed with prMerged = True
  | PrReOpened
  | PrEdited
  | PrSynchronized
  | PrAssigned
  | PrUnassigned
  | PrLabelUpdated
  | PrLabelCleared
  | PrMilestoned
  | PrDemilestoned
  | PrReviewed
  | PrReviewRequested
  | PrReviewRequestRemoved
  | PrUnknown Text -- unhandled action
  deriving stock (Eq, Generic, Show)

actionText :: HookPullRequestAction -> Text
actionText = \case
  PrOpened -> "opened"
  PrClosed -> "closed"
  PrReOpened -> "reopened"
  PrEdited -> "edited"
  PrSynchronized -> "synchronized"
  PrAssigned -> "assigned"
  PrUnassigned -> "unassigned"
  PrLabelUpdated -> "label_updated"
  PrLabelCleared -> "label_cleared"
  PrMilestoned -> "milestoned"
  PrDemilestoned -> "demilestoned"
  PrReviewed -> "reviewed"
  PrReviewRequested -> "review_requested"
  PrReviewRequestRemoved -> "review_request_removed"
  PrUnknown t -> t

knownActions :: [HookPullRequestAction]
knownActions =
  [ PrOpened
  , PrClosed
  , PrReOpened
  , PrEdited
  , PrSynchronized
  , PrAssigned
  , PrUnassigned
  , PrLabelUpdated
  , PrLabelCleared
  , PrMilestoned
  , PrDemilestoned
  , PrReviewed
  , PrReviewRequested
  , PrReviewRequestRemoved
  ]

instance FromJSON HookPullRequestAction where
  parseJSON = AE.withText "HookPullRequestAction" \t ->
    pure $ fromMaybe (PrUnknown t) (lookup t [(actionText a, a) | a <- knownActions])

instance ToJSON HookPullRequestAction where
  toJSON = AE.String . actionText
  toEncoding = AE.text . actionText

instance FromJSON PullRequestPayload where
  parseJSON = genericParseJSON prpOptions

instance ToJSON PullRequestPayload where
  toJSON = genericToJSON prpOptions
