{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIInvalidTopicsError
  ( APIInvalidTopicsError (..)
  , APIInvalidTopicsErrorPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIInvalidTopicsError = APIInvalidTopicsError
  { invalidTopics :: [Text]
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON APIInvalidTopicsError where
  parseJSON = withObject "APIInvalidTopicsError" $ \o ->
    APIInvalidTopicsError
      <$> o .: "invalidTopics"
      <*> o .: "url"

instance ToJSON APIInvalidTopicsError where
  toJSON = genericToJSON runOptions

data APIInvalidTopicsErrorPayload = APIInvalidTopicsErrorPayload
  { arpAction :: Text
  , arpRun :: APIInvalidTopicsError
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIInvalidTopicsErrorPayload where
  parseJSON = withObject "APIInvalidTopicsErrorPayload" $ \o ->
    APIInvalidTopicsErrorPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON APIInvalidTopicsErrorPayload where
  toJSON = genericToJSON arpOptions
