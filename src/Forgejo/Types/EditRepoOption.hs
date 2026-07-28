{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditRepoOption
  ( EditRepoOption (..)
  , EditRepoOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.ExternalTracker (ExternalTracker)
import Forgejo.Types.ExternalWiki (ExternalWiki)
import Forgejo.Types.InternalTracker (InternalTracker)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditRepoOption = EditRepoOption
  { allowFastForwardOnlyMerge :: Bool
  , allowManualMerge :: Bool
  , allowMergeCommits :: Bool
  , allowRebase :: Bool
  , allowRebaseExplicit :: Bool
  , allowRebaseUpdate :: Bool
  , allowSquashMerge :: Bool
  , archived :: Bool
  , autodetectManualMerge :: Bool
  , defaultAllowMaintainerEdit :: Bool
  , defaultBranch :: Text
  , defaultDeleteBranchAfterMerge :: Bool
  , defaultMergeStyle :: Text -- set to a merge style to be used by this repository: "merge", "rebase", "rebase-merge", "squash", "fast-forward-only", "manually-merged", or "rebase-update-only"
  , defaultUpdateStyle :: Text
  , description :: Text
  , enablePrune :: Bool
  , externalTracker :: ExternalTracker
  , externalWiki :: ExternalWiki
  , globallyEditableWiki :: Bool
  , hasActions :: Bool
  , hasIssues :: Bool
  , hasPackages :: Bool
  , hasProjects :: Bool
  , hasPullRequests :: Bool
  , hasReleases :: Bool
  , hasWiki :: Bool
  , ignoreWhitespaceConflicts :: Bool
  , internalTracker :: InternalTracker
  , mirrorInterval :: Text -- example: 8hm300s
  , name :: Text
  , private :: Bool
  , template :: Bool
  , website :: Text
  , wikiBranch :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditRepoOption where
  parseJSON = withObject "EditRepoOption" $ \o ->
    EditRepoOption
      <$> o .: "allow_fast_forward_only_merge"
      <*> o .: "allow_manual_merge"
      <*> o .: "allow_merge_commits"
      <*> o .: "allow_rebase"
      <*> o .: "allow_rebase_explicit"
      <*> o .: "allow_rebase_update"
      <*> o .: "allow_rebase_merge"
      <*> o .: "archived"
      <*> o .: "autodetect_manual_merge"
      <*> o .: "default_allow_maintainer_edit"
      <*> o .: "default_branch"
      <*> o .: "default_delete_branch_after_merge"
      <*> o .: "default_merge_style"
      <*> o .: "default_update_style"
      <*> o .: "description"
      <*> o .: "enable_prune"
      <*> o .: "external_tracker"
      <*> o .: "external_wiki"
      <*> o .: "globally_editable_wiki"
      <*> o .: "has_actions"
      <*> o .: "has_issues"
      <*> o .: "has_packages"
      <*> o .: "has_projects"
      <*> o .: "has_pull_requests"
      <*> o .: "has_releases"
      <*> o .: "has_wiki"
      <*> o .: "ignore_whitespace_conflicts"
      <*> o .: "internal_tracker"
      <*> o .: "mirror_interval"
      <*> o .: "name"
      <*> o .: "private"
      <*> o .: "template"
      <*> o .: "website"
      <*> o .: "wiki_branch"

instance ToJSON EditRepoOption where
  toJSON = genericToJSON runOptions

data EditRepoOptionPayload = EditRepoOptionPayload
  { arpAction :: Text
  , arpRun :: EditRepoOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditRepoOptionPayload where
  parseJSON = withObject "EditRepoOptionPayload" $ \o ->
    EditRepoOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditRepoOptionPayload where
  toJSON = genericToJSON arpOptions
