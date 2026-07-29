{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateTeamOption
  ( CreateTeamOption (..)
  , CreateTeamOptionPayload (..)
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

data CreateTeamOption = CreateTeamOption
  { canCreateOrgRepo :: Bool
  , description :: Text
  , includesAllRepositories :: Bool
  , name :: Text
  , permission :: Permission
  , units :: [Text]
  , unitsMap :: [Text] -- FIXME: example - < * >: { "repo.actions": "none", "repo.code": "read" }
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateTeamOption where
  parseJSON = withObject "CreateTeamOption" $ \o ->
    CreateTeamOption
      <$> o .: "can_create_org_repo"
      <*> o .: "description"
      <*> o .: "includes_all_repositories"
      <*> o .: "name"
      <*> o .: "permission"
      <*> o .: "units"
      <*> o .: "units_map"

instance ToJSON CreateTeamOption where
  toJSON = genericToJSON runOptions

data CreateTeamOptionPayload = CreateTeamOptionPayload
  { arpAction :: Text
  , arpRun :: CreateTeamOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateTeamOptionPayload where
  parseJSON = withObject "CreateTeamOptionPayload" $ \o ->
    CreateTeamOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateTeamOptionPayload where
  toJSON = genericToJSON arpOptions
