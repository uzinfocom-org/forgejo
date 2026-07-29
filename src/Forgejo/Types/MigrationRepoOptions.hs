{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.MigrationRepoOptions
  ( MigrationRepoOptions (..)
  , MigrationRepoOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data MigrationRepoOptions = MigrationRepoOptions
  { authPassword :: Text
  , authToken :: Text
  , authUsername :: Text
  , cloneAddr :: Text
  , description :: Text
  , issues :: Bool
  , labels :: Bool
  , lfs :: Bool
  , lfsEndpoint :: Text
  , milestones :: Bool
  , mirror :: Bool
  , mirrorInterval :: Text
  , private :: Bool
  , pullRequests :: Bool
  , releases :: Bool
  , repoName :: Text
  , repoOwner :: Text -- new repo owner after migration
  , service :: Text -- [ git, github, gitea, gitlab, gogs, onedev, gitbucket, codebase ]
  , uid :: Int
  , wiki :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON MigrationRepoOptions where
  parseJSON = withObject "MigrationRepoOptions" $ \o ->
    MigrationRepoOptions
      <$> o .: "auth_password"
      <*> o .: "auth_token"
      <*> o .: "auth_username"
      <*> o .: "clone_addr"
      <*> o .: "description"
      <*> o .: "issues"
      <*> o .: "labels"
      <*> o .: "lfs"
      <*> o .: "lfs_endpoint"
      <*> o .: "milestones"
      <*> o .: "mirror"
      <*> o .: "mirror_interval"
      <*> o .: "private"
      <*> o .: "pull_requests"
      <*> o .: "releases"
      <*> o .: "repo_name"
      <*> o .: "repo_owner"
      <*> o .: "service"
      <*> o .: "uid"
      <*> o .: "wiki"

instance ToJSON MigrationRepoOptions where
  toJSON = genericToJSON runOptions

data MigrationRepoOptionsPayload = MigrationRepoOptionsPayload
  { arpAction :: Text
  , arpRun :: MigrationRepoOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON MigrationRepoOptionsPayload where
  parseJSON = withObject "MigrationRepoOptionsPayload" $ \o ->
    MigrationRepoOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON MigrationRepoOptionsPayload where
  toJSON = genericToJSON arpOptions
