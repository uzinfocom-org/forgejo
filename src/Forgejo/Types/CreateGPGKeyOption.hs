{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateGPGKeyOption
  ( CreateGPGKeyOption (..)
  , CreateGPGKeyOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateGPGKeyOption = CreateGPGKeyOption
  { armoredPublicKey :: String
  , armoredSignature :: String
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateGPGKeyOption where
  parseJSON = withObject "CreateGPGKeyOption" $ \o ->
    CreateGPGKeyOption
      <$> o .: "armored_public_key"
      <*> o .: "armored_signature"

instance ToJSON CreateGPGKeyOption where
  toJSON = genericToJSON runOptions

data CreateGPGKeyOptionPayload = CreateGPGKeyOptionPayload
  { arpAction :: Text
  , arpRun :: CreateGPGKeyOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateGPGKeyOptionPayload where
  parseJSON = withObject "CreateGPGKeyOptionPayload" $ \o ->
    CreateGPGKeyOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateGPGKeyOptionPayload where
  toJSON = genericToJSON arpOptions
