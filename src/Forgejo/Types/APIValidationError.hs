{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIValidationError
  ( APIValidationError (..)
  , APIValidationErrorPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIValidationError = APIValidationError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON APIValidationError where
  parseJSON = withObject "APIValidationError" $ \o ->
    APIValidationError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIValidationError where
  toJSON = genericToJSON runOptions

data APIValidationErrorPayload = APIValidationErrorPayload
  { arpAction :: Text
  , arpRun :: APIValidationError
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIValidationErrorPayload where
  parseJSON = withObject "APIValidationErrorPayload" $ \o ->
    APIValidationErrorPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON APIValidationErrorPayload where
  toJSON = genericToJSON arpOptions
