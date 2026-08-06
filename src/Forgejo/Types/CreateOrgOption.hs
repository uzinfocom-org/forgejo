{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateOrgOption
  ( CreateOrgOption (..)
  , CreateOrgOptionPayload (..)
  , Visibility
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Visibility = Public | Limited | Private
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data CreateOrgOption = CreateOrgOption
  { description :: Text
  , email :: Text
  , fullName :: Text
  , location :: Text
  , repoAdminCanChangeTeamAccess :: Bool
  , username :: Text
  , visibility :: Visibility
  , website :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateOrgOption where
  parseJSON = withObject "CreateOrgOption" $ \o ->
    CreateOrgOption
      <$> o .: "decsription"
      <*> o .: "email"
      <*> o .: "full_name"
      <*> o .: "location"
      <*> o .: "repo_admin_change_team_access"
      <*> o .: "username"
      <*> o .: "visibility"
      <*> o .: "website"

instance ToJSON CreateOrgOption where
  toJSON = genericToJSON runOptions

data CreateOrgOptionPayload = CreateOrgOptionPayload
  { arpAction :: Text
  , arpRun :: CreateOrgOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateOrgOptionPayload where
  parseJSON = withObject "CreateOrgOptionPayload" $ \o ->
    CreateOrgOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateOrgOptionPayload where
  toJSON = genericToJSON arpOptions
