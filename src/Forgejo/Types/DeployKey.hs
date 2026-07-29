{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.DeployKey
  ( DeployKey (..)
  , DeployKeyPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Repository (Repository)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data DeployKey = DeployKey
  { createdAt :: UTCTime
  , fingerprint :: Text
  , id :: Int
  , key :: Text
  , keyId :: Int
  , readOnly :: Bool
  , repository :: Repository
  , title :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON DeployKey where
  parseJSON = withObject "DeployKey" $ \o ->
    DeployKey
      <$> o .: "created_at"
      <*> o .: "fingerprint"
      <*> o .: "id"
      <*> o .: "key"
      <*> o .: "key_id"
      <*> o .: "read_only"
      <*> o .: "repository"
      <*> o .: "title"
      <*> o .: "url"

instance ToJSON DeployKey where
  toJSON = genericToJSON runOptions

data DeployKeyPayload = DeployKeyPayload
  { arpAction :: Text
  , arpRun :: DeployKey
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON DeployKeyPayload where
  parseJSON = withObject "DeployKeyPayload" $ \o ->
    DeployKeyPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON DeployKeyPayload where
  toJSON = genericToJSON arpOptions
