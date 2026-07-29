{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.MergePullRequestOption
  ( MergePullRequestOption (..)
  , MergePullRequestOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data MergePullRequestOption = MergePullRequestOption
  { mproDo :: Text -- merge, rebase, rebase-merge, squash, fast-forward-only, manually-merged
  , mergeCommitId :: Text
  , mergeMessageField :: Text
  , mergeTitleField :: Text
  , deleteBranchAfterMerge :: Bool
  , forceMerge :: Bool
  , headCommitId :: Text
  , mergeWhenChecksSucceed :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON MergePullRequestOption where
  parseJSON = withObject "MergePullRequestOption" $ \o ->
    MergePullRequestOption
      <$> o .: "Do"
      <*> o .: "MergeCommitID"
      <*> o .: "MergeMessageField"
      <*> o .: "MergeTitleField"
      <*> o .: "delete_branch_after_merge"
      <*> o .: "force_merge"
      <*> o .: "head_commit_id"
      <*> o .: "merge_when_checks_succeed"

instance ToJSON MergePullRequestOption where
  toJSON = genericToJSON runOptions

data MergePullRequestOptionPayload = MergePullRequestOptionPayload
  { arpAction :: Text
  , arpRun :: MergePullRequestOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON MergePullRequestOptionPayload where
  parseJSON = withObject "MergePullRequestOptionPayload" $ \o ->
    MergePullRequestOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON MergePullRequestOptionPayload where
  toJSON = genericToJSON arpOptions
