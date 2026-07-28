{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateOrUpdateSecretOption
  ( CreateOrUpdateSecretOption (..)
  , CreateOrUpdateSecretOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateOrUpdateSecretOption = CreateOrUpdateSecretOption
  { sData :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateOrUpdateSecretOption where
  parseJSON = withObject "CreateOrUpdateSecretOption" $ \o ->
    CreateOrUpdateSecretOption
      <$> o .: "data"

instance ToJSON CreateOrUpdateSecretOption where
  toJSON = genericToJSON runOptions

data CreateOrUpdateSecretOptionPayload = CreateOrUpdateSecretOptionPayload
  { arpAction :: Text
  , arpRun :: CreateOrUpdateSecretOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateOrUpdateSecretOptionPayload where
  parseJSON = withObject "CreateOrUpdateSecretOptionPayload" $ \o ->
    CreateOrUpdateSecretOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateOrUpdateSecretOptionPayload where
  toJSON = genericToJSON arpOptions
