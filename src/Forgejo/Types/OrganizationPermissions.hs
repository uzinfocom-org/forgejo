{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.OrganizationPermissions
  ( OrganizationPermissions (..)
  , OrganizationPermissionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data OrganizationPermissions = OrganizationPermissions
  { canCreateRepository :: Bool
  , canRead :: Bool
  , canWrite :: Bool
  , isAdmin :: Bool
  , isOwner :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON OrganizationPermissions where
  parseJSON = withObject "OrganizationPermissions" $ \o ->
    OrganizationPermissions
      <$> o .: "can_create_repository"
      <*> o .: "can_read"
      <*> o .: "can_write"
      <*> o .: "is_admin"
      <*> o .: "is_owner"

instance ToJSON OrganizationPermissions where
  toJSON = genericToJSON runOptions

data OrganizationPermissionsPayload = OrganizationPermissionsPayload
  { arpAction :: Text
  , arpRun :: OrganizationPermissions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON OrganizationPermissionsPayload where
  parseJSON = withObject "OrganizationPermissionsPayload" $ \o ->
    OrganizationPermissionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON OrganizationPermissionsPayload where
  toJSON = genericToJSON arpOptions
