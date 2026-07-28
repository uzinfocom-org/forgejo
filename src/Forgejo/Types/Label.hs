{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Label
  ( Label (..)
  , LabelPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Label = Label
  { color :: Text
  , description :: Text
  , exclusive :: Bool
  , id :: Int
  , isArchived :: Bool
  , name :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Label where
  parseJSON = withObject "Label" $ \o ->
    Label
      <$> o .: "color"
      <*> o .: "description"
      <*> o .: "exclusive"
      <*> o .: "id"
      <*> o .: "is_archived"
      <*> o .: "name"
      <*> o .: "url"

instance ToJSON Label where
  toJSON = genericToJSON runOptions

data LabelPayload = LabelPayload
  { arpAction :: Text
  , arpRun :: Label
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON LabelPayload where
  parseJSON = withObject "LabelPayload" $ \o ->
    LabelPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON LabelPayload where
  toJSON = genericToJSON arpOptions
