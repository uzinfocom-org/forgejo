{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.BranchProtection
  ( BranchProtection (..)
  , BranchProtectionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data BranchProtection = BranchProtection
  { applyToAdmins :: Bool
  , approvalsWhitelistTeams :: [Text]
  , blockOnOfficialReviewRequests :: Bool
  , blockOnOutdatedBranch :: Bool
  , blockOnRejectedReviews :: Bool
  , branchName :: Text
  , createdAt :: UTCTime
  , dismissStaleApprovals :: Bool
  , enableApprovalsWhitelist :: Bool
  , enableMergeWhitelist :: Bool
  , enablePush :: Bool
  , enablePushWhitelist :: Bool
  , enableStatusCheck :: Bool
  , ignoreStaleApprovals :: Bool
  , mergeWhitelistTeams :: [Text]
  , mergeWhitelistUsernames :: [Text]
  , protectedFilePatterns :: Text
  , pushWhitelistDeployKeys :: Bool
  , pushWhitelistTeams :: [Text]
  , pushWhitelistUsernames :: [Text]
  , requireSignedCommits :: Bool
  , requiredApprovals :: Int
  , ruleName :: Text
  , statusCheckContexts :: [Text]
  , unprotectedFilePatterns :: Text
  , updatedAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON BranchProtection where
  parseJSON = withObject "BranchProtection" $ \o ->
    BranchProtection
      <$> o .: "apply_to_admins"
      <*> o .: "approvals_whitelist_teams"
      <*> o .: "block_on_official_review_requests"
      <*> o .: "block_on_outdated_branch"
      <*> o .: "block_on_rejected_reviews"
      <*> o .: "branch_name"
      <*> o .: "created_at"
      <*> o .: "dismiss_stale_approvals"
      <*> o .: "enable_approvals_whitelist"
      <*> o .: "enable_merge_whitelist"
      <*> o .: "enable_push"
      <*> o .: "enable_push_whitelist"
      <*> o .: "enable_status_check"
      <*> o .: "ignore_stale_approvals"
      <*> o .: "merge_whitelist_teams"
      <*> o .: "merge_whitelist_usernames"
      <*> o .: "protected_file_patterns"
      <*> o .: "push_whitelist_deploy_keys"
      <*> o .: "push_whitelist_teams"
      <*> o .: "push_whitelist_usernames"
      <*> o .: "require_signed_commits"
      <*> o .: "required_approvals"
      <*> o .: "rule_name"
      <*> o .: "status_check_contexts"
      <*> o .: "unprotected_file_patterns"
      <*> o .: "updated_at"

instance ToJSON BranchProtection where
  toJSON = genericToJSON runOptions

data BranchProtectionPayload = BranchProtectionPayload
  { arpAction :: Text
  , arpRun :: BranchProtection
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON BranchProtectionPayload where
  parseJSON = withObject "BranchProtectionPayload" $ \o ->
    BranchProtectionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON BranchProtectionPayload where
  toJSON = genericToJSON arpOptions
