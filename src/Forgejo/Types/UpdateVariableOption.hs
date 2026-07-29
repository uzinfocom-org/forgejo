{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.UpdateVariableOption
  ( UpdateVariableOption (..)
  , UpdateVariableOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data UpdateVariableOption = UpdateVariableOption
  { name :: Text
  , value :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON UpdateVariableOption where
  parseJSON = withObject "UpdateVariableOption" $ \o ->
    UpdateVariableOption
      <$> o .: "name"
      <*> o .: "value"

instance ToJSON UpdateVariableOption where
  toJSON = genericToJSON runOptions

data UpdateVariableOptionPayload = UpdateVariableOptionPayload
  { arpAction :: Text
  , arpRun :: UpdateVariableOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON UpdateVariableOptionPayload where
  parseJSON = withObject "UpdateVariableOptionPayload" $ \o ->
    UpdateVariableOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON UpdateVariableOptionPayload where
  toJSON = genericToJSON arpOptions
