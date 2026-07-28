{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Secret
  ( Secret (..)
  , SecretPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Secret = Secret
  { createdAt :: UTCTime
  , name :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Secret where
  parseJSON = withObject "Secret" $ \o ->
    Secret
      <$> o .: "created_at"
      <*> o .: "name"

instance ToJSON Secret where
  toJSON = genericToJSON runOptions

data SecretPayload = SecretPayload
  { arpAction :: Text
  , arpRun :: Secret
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON SecretPayload where
  parseJSON = withObject "SecretPayload" $ \o ->
    SecretPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON SecretPayload where
  toJSON = genericToJSON arpOptions
