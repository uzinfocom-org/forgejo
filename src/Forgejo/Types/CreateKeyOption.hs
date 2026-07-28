{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateKeyOption
  ( CreateKeyOption (..)
  , CreateKeyOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateKeyOption = CreateKeyOption
  { key :: Text
  , readOnly :: Bool
  , title :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateKeyOption where
  parseJSON = withObject "CreateKeyOption" $ \o ->
    CreateKeyOption
      <$> o .: "key"
      <*> o .: "read_only"
      <*> o .: "title"

instance ToJSON CreateKeyOption where
  toJSON = genericToJSON runOptions

data CreateKeyOptionPayload = CreateKeyOptionPayload
  { arpAction :: Text
  , arpRun :: CreateKeyOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateKeyOptionPayload where
  parseJSON = withObject "CreateKeyOptionPayload" $ \o ->
    CreateKeyOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateKeyOptionPayload where
  toJSON = genericToJSON arpOptions
