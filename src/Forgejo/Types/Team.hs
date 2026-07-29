{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Team
  ( Team (..)
  , TeamPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.Organization (Organization)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Team = Team
  { canCreateOrgRepo :: Bool
  , description :: Text
  , id :: Int
  , includesAllRepositories :: Bool
  , name :: Text
  , organization :: Organization
  , permission :: Text -- [ none, read, write, admin, owner ]
  , units :: [Text] -- example from original: [ "repo.code", "repo.issues", "repo.ext_issues", "repo.wiki", "repo.pulls", "repo.releases", "repo.projects", "repo.ext_wiki" ]
  , unitsMap :: ()
  }
  -- original: { <*>: string }

  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Team where
  parseJSON = withObject "Team" $ \o ->
    Team
      <$> o .: "can_create_org_repo"
      <*> o .: "description"
      <*> o .: "id"
      <*> o .: "includes_all_repositories"
      <*> o .: "name"
      <*> o .: "organization"
      <*> o .: "permission"
      <*> o .: "units"
      <*> o .: "units_map"

instance ToJSON Team where
  toJSON = genericToJSON runOptions

data TeamPayload = TeamPayload
  { arpAction :: Text
  , arpRun :: Team
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON TeamPayload where
  parseJSON = withObject "TeamPayload" $ \o ->
    TeamPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON TeamPayload where
  toJSON = genericToJSON arpOptions
