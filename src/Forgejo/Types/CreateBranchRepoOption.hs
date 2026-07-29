{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateBranchRepoOption
  ( CreateBranchRepoOption (..)
  , CreateBranchRepoOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateBranchRepoOption = CreateBranchRepoOption
  { newBranchName :: Text
  , oldBranchName :: Text
  , oldRefName :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateBranchRepoOption where
  parseJSON = withObject "CreateBranchRepoOption" $ \o ->
    CreateBranchRepoOption
      <$> o .: "new_branch_name"
      <*> o .: "old_branch_name"
      <*> o .: "old_ref_name"

instance ToJSON CreateBranchRepoOption where
  toJSON = genericToJSON runOptions

data CreateBranchRepoOptionPayload = CreateBranchRepoOptionPayload
  { arpAction :: Text
  , arpRun :: CreateBranchRepoOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateBranchRepoOptionPayload where
  parseJSON = withObject "CreateBranchRepoOptionPayload" $ \o ->
    CreateBranchRepoOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateBranchRepoOptionPayload where
  toJSON = genericToJSON arpOptions
