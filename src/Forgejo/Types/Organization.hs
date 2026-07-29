{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Organization
  ( Organization (..)
  , OrganizationPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Organization = Organization
  { avatarUrl :: Text
  , description :: Text
  , email :: Text
  , fullName :: Text
  , id :: Int
  , location :: Text
  , name :: Text
  , repoAdminChangeTeamAccess :: Bool
  , visibility :: Text
  , website :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Organization where
  parseJSON = withObject "Organization" $ \o ->
    Organization
      <$> o .: "avatar_url"
      <*> o .: "description"
      <*> o .: "email"
      <*> o .: "full_name"
      <*> o .: "id"
      <*> o .: "location"
      <*> o .: "name"
      <*> o .: "repo_admin_change_team_access"
      <*> o .: "visibility"
      <*> o .: "website"

instance ToJSON Organization where
  toJSON = genericToJSON runOptions

data OrganizationPayload = OrganizationPayload
  { arpAction :: Text
  , arpRun :: Organization
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON OrganizationPayload where
  parseJSON = withObject "OrganizationPayload" $ \o ->
    OrganizationPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON OrganizationPayload where
  toJSON = genericToJSON arpOptions
