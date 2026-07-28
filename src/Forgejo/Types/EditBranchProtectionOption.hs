{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditBranchProtectionOption
  ( EditBranchProtectionOption (..)
  , EditBranchProtectionOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditBranchProtectionOption = EditBranchProtectionOption
  { applyToAdmins :: Bool
  , approvalsWhitelistTeams :: [Text]
  , approvalsWhitelistUsername :: [Text]
  , blockOnOfficialReviewRequests :: Bool
  , blockOnOutdatedBranch :: Bool
  , blockOnRejectedReviews :: Bool
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
  , statusCheckContexts :: [Text]
  , unprotectedFilePatterns :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditBranchProtectionOption where
  parseJSON = withObject "EditBranchProtectionOption" $ \o ->
    EditBranchProtectionOption
      <$> o .: "apply_to_admins"
      <*> o .: "approvals_whitelist_teams"
      <*> o .: "approvals_whitelist_username"
      <*> o .: "block_on_official_review_requests"
      <*> o .: "block_on_outdated_branch"
      <*> o .: "block_on_rejected_reviews"
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
      <*> o .: "status_check_contexts"
      <*> o .: "unprotected_file_patterns"

instance ToJSON EditBranchProtectionOption where
  toJSON = genericToJSON runOptions

data EditBranchProtectionOptionPayload = EditBranchProtectionOptionPayload
  { arpAction :: Text
  , arpRun :: EditBranchProtectionOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditBranchProtectionOptionPayload where
  parseJSON = withObject "EditBranchProtectionOptionPayload" $ \o ->
    EditBranchProtectionOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditBranchProtectionOptionPayload where
  toJSON = genericToJSON arpOptions
