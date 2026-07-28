{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GPGKeyEmail
  ( GPGKeyEmail (..)
  , GPGKeyEmailPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GPGKeyEmail = GPGKeyEmail
  { email :: Text
  , verified :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GPGKeyEmail where
  parseJSON = withObject "GPGKeyEmail" $ \o ->
    GPGKeyEmail
      <$> o .: "email"
      <*> o .: "verified"

instance ToJSON GPGKeyEmail where
  toJSON = genericToJSON runOptions

data GPGKeyEmailPayload = GPGKeyEmailPayload
  { arpAction :: Text
  , arpRun :: GPGKeyEmail
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GPGKeyEmailPayload where
  parseJSON = withObject "GPGKeyEmailPayload" $ \o ->
    GPGKeyEmailPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GPGKeyEmailPayload where
  toJSON = genericToJSON arpOptions
