{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditLabelOption
  ( EditLabelOption (..)
  , EditLabelOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditLabelOption = EditLabelOption
  { color :: Text
  , description :: Text
  , exclusive :: Bool
  , isArchived :: Bool
  , name :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditLabelOption where
  parseJSON = withObject "EditLabelOption" $ \o ->
    EditLabelOption
      <$> o .: "color"
      <*> o .: "description"
      <*> o .: "exclusive"
      <*> o .: "is_archived"
      <*> o .: "name"

instance ToJSON EditLabelOption where
  toJSON = genericToJSON runOptions

data EditLabelOptionPayload = EditLabelOptionPayload
  { arpAction :: Text
  , arpRun :: EditLabelOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditLabelOptionPayload where
  parseJSON = withObject "EditLabelOptionPayload" $ \o ->
    EditLabelOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditLabelOptionPayload where
  toJSON = genericToJSON arpOptions
