{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Identity
  ( Identity (..)
  , IdentityPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Identity = Identity
  { email :: Text
  , name :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Identity where
  parseJSON = withObject "Identity" $ \o ->
    Identity
      <$> o .: "email"
      <*> o .: "name"

instance ToJSON Identity where
  toJSON = genericToJSON runOptions

data IdentityPayload = IdentityPayload
  { arpAction :: Text
  , arpRun :: Identity
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IdentityPayload where
  parseJSON = withObject "IdentityPayload" $ \o ->
    IdentityPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON IdentityPayload where
  toJSON = genericToJSON arpOptions
