{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditOrgOption
  ( EditOrgOption (..)
  , EditOrgOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.CreateOrgOption (Visibility)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditOrgOption = EditOrgOption
  { description :: Text
  , email :: Text
  , fullName :: Text
  , location :: Text
  , repoAdminChangeTeamAccess :: Bool
  , visibility :: Visibility
  , website :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditOrgOption where
  parseJSON = withObject "EditOrgOption" $ \o ->
    EditOrgOption
      <$> o .: "description"
      <*> o .: "email"
      <*> o .: "full_name"
      <*> o .: "location"
      <*> o .: "repo_admin_change_team_access"
      <*> o .: "visibility"
      <*> o .: "website"

instance ToJSON EditOrgOption where
  toJSON = genericToJSON runOptions

data EditOrgOptionPayload = EditOrgOptionPayload
  { arpAction :: Text
  , arpRun :: EditOrgOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditOrgOptionPayload where
  parseJSON = withObject "EditOrgOptionPayload" $ \o ->
    EditOrgOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditOrgOptionPayload where
  toJSON = genericToJSON arpOptions
