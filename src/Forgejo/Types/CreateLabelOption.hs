{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateLabelOption
  ( CreateLabelOption (..)
  , CreateLabelOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateLabelOption = CreateLabelOption
  { color :: Text
  , description :: Text
  , exclusive :: Bool
  , isArchived :: Bool
  , name :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateLabelOption where
  parseJSON = withObject "CreateLabelOption" $ \o ->
    CreateLabelOption
      <$> o .: "color"
      <*> o .: "description"
      <*> o .: "exclusive"
      <*> o .: "is_archived"
      <*> o .: "name"

instance ToJSON CreateLabelOption where
  toJSON = genericToJSON runOptions

data CreateLabelOptionPayload = CreateLabelOptionPayload
  { arpAction :: Text
  , arpRun :: CreateLabelOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateLabelOptionPayload where
  parseJSON = withObject "CreateLabelOptionPayload" $ \o ->
    CreateLabelOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateLabelOptionPayload where
  toJSON = genericToJSON arpOptions
