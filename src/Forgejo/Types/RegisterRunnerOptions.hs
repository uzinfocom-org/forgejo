{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RegisterRunnerOptions
  ( RegisterRunnerOptions (..)
  , RegisterRunnerOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RegisterRunnerOptions = RegisterRunnerOptions
  { description :: Text
  , ephemeral :: Bool
  , name :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RegisterRunnerOptions where
  parseJSON = withObject "RegisterRunnerOptions" $ \o ->
    RegisterRunnerOptions
      <$> o .: "description"
      <*> o .: "ephemeral"
      <*> o .: "name"

instance ToJSON RegisterRunnerOptions where
  toJSON = genericToJSON runOptions

data RegisterRunnerOptionsPayload = RegisterRunnerOptionsPayload
  { arpAction :: Text
  , arpRun :: RegisterRunnerOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RegisterRunnerOptionsPayload where
  parseJSON = withObject "RegisterRunnerOptionsPayload" $ \o ->
    RegisterRunnerOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RegisterRunnerOptionsPayload where
  toJSON = genericToJSON arpOptions
