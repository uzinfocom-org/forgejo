{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditTeamOption
  ( EditTeamOption (..)
  , EditTeamOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.AddCollaboratorOption (Permission)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditTeamOption = EditTeamOption
  { canCreateOrgRepo :: Bool
  , description :: Text
  , includesAllRepositories :: Bool
  , name :: Text
  , permission :: Permission
  , units :: Text -- example: [ "repo.code", "repo.issues", "repo.ext_issues", "repo.wiki", "repo.pulls", "repo.releases", "repo.projects", "repo.ext_wiki" ]
  , unitsMap :: Text -- { <*>: Text } example: { "repo.actions": "none", "repo.code": "read", "repo.ext_issues": "none", "repo.ext_wiki": "none", "repo.issues": "write", "repo.packages": "none", "repo.projects": "none", "repo.pulls": "owner", "repo.releases": "none", "repo.wiki": "admin" }
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditTeamOption where
  parseJSON = withObject "EditTeamOption" $ \o ->
    EditTeamOption
      <$> o .: "can_create_org_repo"
      <*> o .: "description"
      <*> o .: "includes_all_repositories"
      <*> o .: "name"
      <*> o .: "permission"
      <*> o .: "units"
      <*> o .: "units_map"

instance ToJSON EditTeamOption where
  toJSON = genericToJSON runOptions

data EditTeamOptionPayload = EditTeamOptionPayload
  { arpAction :: Text
  , arpRun :: EditTeamOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditTeamOptionPayload where
  parseJSON = withObject "EditTeamOptionPayload" $ \o ->
    EditTeamOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditTeamOptionPayload where
  toJSON = genericToJSON arpOptions
