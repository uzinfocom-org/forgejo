{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Permission
  ( Permission (..)
  , PermissionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Permission = Permission
  { admin :: Bool
  , pull :: Bool
  , push :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Permission where
  parseJSON = withObject "Permission" $ \o ->
    Permission
      <$> o .: "admin"
      <*> o .: "pull"
      <*> o .: "push"

instance ToJSON Permission where
  toJSON = genericToJSON runOptions

data PermissionPayload = PermissionPayload
  { arpAction :: Text
  , arpRun :: Permission
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PermissionPayload where
  parseJSON = withObject "PermissionPayload" $ \o ->
    PermissionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PermissionPayload where
  toJSON = genericToJSON arpOptions
