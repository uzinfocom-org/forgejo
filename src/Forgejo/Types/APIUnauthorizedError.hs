{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIUnauthorizedError
  ( APIUnauthorizedError (..)
  , APIUnauthorizedErrorPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIUnauthorizedError = APIUnauthorizedError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON APIUnauthorizedError where
  parseJSON = withObject "APIUnauthorizedError" $ \o ->
    APIUnauthorizedError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIUnauthorizedError where
  toJSON = genericToJSON runOptions

data APIUnauthorizedErrorPayload = APIUnauthorizedErrorPayload
  { arpAction :: Text
  , arpRun :: APIUnauthorizedError
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIUnauthorizedErrorPayload where
  parseJSON = withObject "APIUnauthorizedErrorPayload" $ \o ->
    APIUnauthorizedErrorPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON APIUnauthorizedErrorPayload where
  toJSON = genericToJSON arpOptions
