{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PRBranchInfo
  ( PRBranchInfo (..)
  , PRBranchInfoPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.Repository (Repository)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PRBranchInfo = PRBranchInfo
  { label :: Text
  , ref :: Text
  , repo :: Repository
  , repoId :: Int
  , sha :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PRBranchInfo where
  parseJSON = withObject "PRBranchInfo" $ \o ->
    PRBranchInfo
      <$> o .: "label"
      <*> o .: "ref"
      <*> o .: "repo"
      <*> o .: "repo_id"
      <*> o .: "sha"

instance ToJSON PRBranchInfo where
  toJSON = genericToJSON runOptions

data PRBranchInfoPayload = PRBranchInfoPayload
  { arpAction :: Text
  , arpRun :: PRBranchInfo
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PRBranchInfoPayload where
  parseJSON = withObject "PRBranchInfoPayload" $ \o ->
    PRBranchInfoPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PRBranchInfoPayload where
  toJSON = genericToJSON arpOptions
