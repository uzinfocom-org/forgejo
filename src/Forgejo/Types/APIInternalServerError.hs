{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIInternalServerError
  ( APIInternalServerError (..)
  , APIInternalServerErrorPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIInternalServerError = APIInternalServerError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON APIInternalServerError where
  parseJSON = withObject "APIInternalServerError" $ \o ->
    APIInternalServerError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIInternalServerError where
  toJSON = genericToJSON runOptions

data APIInternalServerErrorPayload = APIInternalServerErrorPayload
  { arpAction :: Text
  , arpRun :: APIInternalServerError
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIInternalServerErrorPayload where
  parseJSON = withObject "APIInternalServerErrorPayload" $ \o ->
    APIInternalServerErrorPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON APIInternalServerErrorPayload where
  toJSON = genericToJSON arpOptions
