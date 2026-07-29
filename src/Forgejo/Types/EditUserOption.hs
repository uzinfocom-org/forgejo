{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditUserOption
  ( EditUserOption (..)
  , EditUserOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditUserOption = EditUserOption
  { active :: Bool
  , admin :: Bool
  , allowCreateOrganization :: Bool
  , allowGitHook :: Bool
  , allowImportLocal :: Bool
  , description :: Text
  , email :: Text
  , fullName :: Text
  , hideEmail :: Bool
  , location :: Text
  , loginName :: Text
  , maxRepoCreation :: Int
  , mustChangePassword :: Bool
  , password :: Text
  , prohibitLogin :: Bool
  , pronouns :: Text
  , restricted :: Bool
  , sourceId :: Int
  , visibility :: Text
  , website :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditUserOption where
  parseJSON = withObject "EditUserOption" $ \o ->
    EditUserOption
      <$> o .: "active"
      <*> o .: "admin"
      <*> o .: "allow_create_organization"
      <*> o .: "allow_git_hook"
      <*> o .: "allow_import_local"
      <*> o .: "description"
      <*> o .: "email"
      <*> o .: "full_name"
      <*> o .: "hide_email"
      <*> o .: "location"
      <*> o .: "login_name"
      <*> o .: "max_repo_creation"
      <*> o .: "must_change_password"
      <*> o .: "password"
      <*> o .: "prohibit_login"
      <*> o .: "pronouns"
      <*> o .: "restricted"
      <*> o .: "source_id"
      <*> o .: "visibility"
      <*> o .: "website"

instance ToJSON EditUserOption where
  toJSON = genericToJSON runOptions

data EditUserOptionPayload = EditUserOptionPayload
  { arpAction :: Text
  , arpRun :: EditUserOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditUserOptionPayload where
  parseJSON = withObject "EditUserOptionPayload" $ \o ->
    EditUserOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditUserOptionPayload where
  toJSON = genericToJSON arpOptions
