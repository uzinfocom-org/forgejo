{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}

module Forgejo.Types.PullRequest
  ( PRBranch (..)
  , PullRequest (..)
  , PullRequestPayload (..)
  , HookPullRequestAction (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value, genericParseJSON, genericToJSON)
import Data.Aeson qualified as AE
import Data.Aeson.Encoding qualified as AE
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
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
  , prAssignees :: Maybe [User] -- Forgejo return instead of empty list. That's why we use Maybe
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

data PullRequestPayload = PullRequestPayload
  { prpAction :: HookPullRequestAction
  , prpNumber :: Int
  , prpPullRequest :: PullRequest
  , prpRequestedReviewer :: Maybe User
  , prpRepository :: Repository
  , prpSender :: User
  , prpCommitId :: Text
  , prpReview :: Maybe Value
  }
  deriving stock (Eq, Generic, Show)

-- TODO: We need to implement all types of hooks inspired from - https://github.com/go-gitea/gitea/blob/6ff3a65708dd6a6472f7b164bb31a842a4c4d672/modules/structs/hook.go#L359-L387
data HookPullRequestAction
  = PrOpened
  | PrClosed
  | PrReOpened
  | PrLabelUpdated
  | PrUnknown Text -- unhandled action
  deriving stock (Eq, Generic, Show)

instance FromJSON HookPullRequestAction where
  parseJSON =
    AE.withText "HookPullRequestAction"
      $ pure . \case
        "opened" -> PrOpened
        "closed" -> PrClosed
        "reopened" -> PrReOpened
        "label_updated" -> PrLabelUpdated
        x -> PrUnknown x

instance ToJSON HookPullRequestAction where
  toJSON = AE.String . fromTaggedHook
  toEncoding = AE.text . fromTaggedHook
fromTaggedHook = \case
  PrOpened -> "opened"
  PrClosed -> "closed"
  PrReOpened -> "reopened"
  PrUnknown t -> t

instance FromJSON PullRequestPayload where
  parseJSON = genericParseJSON prpOptions

instance ToJSON PullRequestPayload where
  toJSON = genericToJSON prpOptions
