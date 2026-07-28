{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIForbiddenError
  ( APIForbiddenError (..)
  , APIForbiddenErrorPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIForbiddenError = APIForbiddenError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON APIForbiddenError where
  parseJSON = withObject "APIForbiddenError" $ \o ->
    APIForbiddenError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIForbiddenError where
  toJSON = genericToJSON runOptions

data APIForbiddenErrorPayload = APIForbiddenErrorPayload
  { arpAction :: Text
  , arpRun :: APIForbiddenError
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIForbiddenErrorPayload where
  parseJSON = withObject "APIForbiddenErrorPayload" $ \o ->
    APIForbiddenErrorPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON APIForbiddenErrorPayload where
  toJSON = genericToJSON arpOptions
