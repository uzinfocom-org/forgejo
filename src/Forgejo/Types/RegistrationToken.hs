{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RegistrationToken
  ( RegistrationToken (..)
  , RegistrationTokenPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RegistrationToken = RegistrationToken
  { token :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RegistrationToken where
  parseJSON = withObject "RegistrationToken" $ \o ->
    RegistrationToken
      <$> o .: "token"

instance ToJSON RegistrationToken where
  toJSON = genericToJSON runOptions

data RegistrationTokenPayload = RegistrationTokenPayload
  { arpAction :: Text
  , arpRun :: RegistrationToken
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RegistrationTokenPayload where
  parseJSON = withObject "RegistrationTokenPayload" $ \o ->
    RegistrationTokenPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RegistrationTokenPayload where
  toJSON = genericToJSON arpOptions
