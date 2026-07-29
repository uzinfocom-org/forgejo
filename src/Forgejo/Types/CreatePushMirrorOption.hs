{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreatePushMirrorOption
  ( CreatePushMirrorOption (..)
  , CreatePushMirrorOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreatePushMirrorOption = CreatePushMirrorOption
  { branchFilter :: Text
  , interval :: Text
  , remoteAddress :: Text
  , remotePassword :: Text
  , remoteUsername :: Text
  , syncOnCommit :: Bool
  , useSsh :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreatePushMirrorOption where
  parseJSON = withObject "CreatePushMirrorOption" $ \o ->
    CreatePushMirrorOption
      <$> o .: "branch_filter"
      <*> o .: "interval"
      <*> o .: "remote_address"
      <*> o .: "remote_password"
      <*> o .: "remote_username"
      <*> o .: "sync_on_commit"
      <*> o .: "use_ssh"

instance ToJSON CreatePushMirrorOption where
  toJSON = genericToJSON runOptions

data CreatePushMirrorOptionPayload = CreatePushMirrorOptionPayload
  { arpAction :: Text
  , arpRun :: CreatePushMirrorOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreatePushMirrorOptionPayload where
  parseJSON = withObject "CreatePushMirrorOptionPayload" $ \o ->
    CreatePushMirrorOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreatePushMirrorOptionPayload where
  toJSON = genericToJSON arpOptions
