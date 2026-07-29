{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.UpdateBranchRepoOption
  ( UpdateBranchRepoOption (..)
  , UpdateBranchRepoOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data UpdateBranchRepoOption = UpdateBranchRepoOption
  { name :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON UpdateBranchRepoOption where
  parseJSON = withObject "UpdateBranchRepoOption" $ \o ->
    UpdateBranchRepoOption
      <$> o .: "name"

instance ToJSON UpdateBranchRepoOption where
  toJSON = genericToJSON runOptions

data UpdateBranchRepoOptionPayload = UpdateBranchRepoOptionPayload
  { arpAction :: Text
  , arpRun :: UpdateBranchRepoOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON UpdateBranchRepoOptionPayload where
  parseJSON = withObject "UpdateBranchRepoOptionPayload" $ \o ->
    UpdateBranchRepoOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON UpdateBranchRepoOptionPayload where
  toJSON = genericToJSON arpOptions
