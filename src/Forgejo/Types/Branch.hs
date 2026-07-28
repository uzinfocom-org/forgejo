{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Branch
  ( Branch (..)
  , BranchPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.PayloadCommit (PayloadCommit)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Branch = Branch
  { commit :: PayloadCommit
  , effectiveBranchProtectionName :: Text
  , enableStatusCheck :: Bool
  , name :: Text
  , protected :: Bool
  , requiredApprovals :: Int
  , statusCheckContexts :: [Text]
  , userCanMerge :: Bool
  , userCanPush :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Branch where
  parseJSON = withObject "Branch" $ \o ->
    Branch
      <$> o .: "commit"
      <*> o .: "effective_branch_protection_name"
      <*> o .: "enable_status_check"
      <*> o .: "name"
      <*> o .: "protected"
      <*> o .: "required_approvals"
      <*> o .: "status_check_contexts"
      <*> o .: "user_can_merge"
      <*> o .: "user_can_push"

instance ToJSON Branch where
  toJSON = genericToJSON runOptions

data BranchPayload = BranchPayload
  { arpAction :: Text
  , arpRun :: Branch
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON BranchPayload where
  parseJSON = withObject "BranchPayload" $ \o ->
    BranchPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON BranchPayload where
  toJSON = genericToJSON arpOptions
