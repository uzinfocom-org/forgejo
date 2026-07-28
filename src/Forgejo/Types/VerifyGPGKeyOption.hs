{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.VerifyGPGKeyOption
  ( VerifyGPGKeyOption (..)
  , VerifyGPGKeyOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data VerifyGPGKeyOption = VerifyGPGKeyOption
  { armoredSignature :: Text
  , keyId :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON VerifyGPGKeyOption where
  parseJSON = withObject "VerifyGPGKeyOption" $ \o ->
    VerifyGPGKeyOption
      <$> o .: "armored_signature"
      <*> o .: "key_id"

instance ToJSON VerifyGPGKeyOption where
  toJSON = genericToJSON runOptions

data VerifyGPGKeyOptionPayload = VerifyGPGKeyOptionPayload
  { arpAction :: Text
  , arpRun :: VerifyGPGKeyOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON VerifyGPGKeyOptionPayload where
  parseJSON = withObject "VerifyGPGKeyOptionPayload" $ \o ->
    VerifyGPGKeyOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON VerifyGPGKeyOptionPayload where
  toJSON = genericToJSON arpOptions
