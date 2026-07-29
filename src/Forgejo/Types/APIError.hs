{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIError
  ( APIError (..)
  , APIErrorPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIError = APIError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON APIError where
  parseJSON = withObject "APIError" $ \o ->
    APIError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIError where
  toJSON = genericToJSON runOptions

data APIErrorPayload = APIErrorPayload
  { arpAction :: Text
  , arpRun :: APIError
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIErrorPayload where
  parseJSON = withObject "APIErrorPayload" $ \o ->
    APIErrorPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON APIErrorPayload where
  toJSON = genericToJSON arpOptions
