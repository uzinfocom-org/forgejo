{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RepoCollaboratorPermission
  ( RepoCollaboratorPermission (..)
  , RepoCollaboratorPermissionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RepoCollaboratorPermission = RepoCollaboratorPermission
  { permission :: Text
  , roleName :: Text
  , user :: User
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RepoCollaboratorPermission where
  parseJSON = withObject "RepoCollaboratorPermission" $ \o ->
    RepoCollaboratorPermission
      <$> o .: "permission"
      <*> o .: "role_name"
      <*> o .: "user"

instance ToJSON RepoCollaboratorPermission where
  toJSON = genericToJSON runOptions

data RepoCollaboratorPermissionPayload = RepoCollaboratorPermissionPayload
  { arpAction :: Text
  , arpRun :: RepoCollaboratorPermission
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RepoCollaboratorPermissionPayload where
  parseJSON = withObject "RepoCollaboratorPermissionPayload" $ \o ->
    RepoCollaboratorPermissionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RepoCollaboratorPermissionPayload where
  toJSON = genericToJSON arpOptions
