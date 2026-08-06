{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Activity
  ( Activity (..)
  , ActivityPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Comment (Comment)
import Forgejo.Types.Repository (Repository)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

apOptions :: Options
apOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

aOptions :: Options
aOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 1}

data OpType
  = CreateRepo
  | RenameRepo
  | StarRepo
  | WatchRepo
  | CommitRepo
  | CreateIssue
  | CreatePullRequest
  | TransferRepo
  | PushTag
  | CommentIssue
  | MergePullRequest
  | CloseIssue
  | ReopenIssue
  | ClosePullRequest
  | ReopenPullRequest
  | DeleteTag
  | DeleteBranch
  | MirrorSyncPush
  | MirrorSyncCreate
  | MirrorSyncDelete
  | ApprovePullRequest
  | RejectPullRequest
  | CommentPull
  | PublishRelease
  | PullReviewDismissed
  | PullRequestReadyForReview
  | AutoMergePullRequest
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data Activity = Activity
  { aActUser :: User
  , aActUserId :: Int
  , aComment :: Comment
  , aCommentId :: Int
  , aContent :: Text
  , aCreated :: UTCTime
  , aId :: Int
  , aIsPrivate :: Bool
  , aOpType :: OpType
  , aRefName :: Text
  , aRepo :: Repository
  , aRepoId :: Int
  , aUserid :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Activity where
  parseJSON = withObject "Activity" $ \o ->
    Activity
      <$> o .: "act_user"
      <*> o .: "act_user_ud"
      <*> o .: "comment"
      <*> o .: "comment_id"
      <*> o .: "content"
      <*> o .: "created"
      <*> o .: "id"
      <*> o .: "is_private"
      <*> o .: "op_type"
      <*> o .: "ref_name"
      <*> o .: "repo"
      <*> o .: "repo_id"
      <*> o .: "user_id"

instance ToJSON Activity where
  toJSON = genericToJSON aOptions

data ActivityPayload = ActivityPayload
  { arpAction :: Text
  , arpRun :: Activity
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ActivityPayload where
  parseJSON = withObject "ActivityPayload" $ \o ->
    ActivityPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ActivityPayload where
  toJSON = genericToJSON apOptions
