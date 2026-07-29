{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.LabelTemplate
  ( LabelTemplate (..)
  , LabelTemplatePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data LabelTemplate = LabelTemplate
  { color :: Text
  , description :: Text
  , exclusive :: Bool
  , name :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON LabelTemplate where
  parseJSON = withObject "LabelTemplate" $ \o ->
    LabelTemplate
      <$> o .: "color"
      <*> o .: "description"
      <*> o .: "exclusive"
      <*> o .: "name"

instance ToJSON LabelTemplate where
  toJSON = genericToJSON runOptions

data LabelTemplatePayload = LabelTemplatePayload
  { arpAction :: Text
  , arpRun :: LabelTemplate
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON LabelTemplatePayload where
  parseJSON = withObject "LabelTemplatePayload" $ \o ->
    LabelTemplatePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON LabelTemplatePayload where
  toJSON = genericToJSON arpOptions
