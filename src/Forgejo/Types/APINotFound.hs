{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APINotFound
  ( APINotFound (..)
  , APINotFoundPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APINotFound = APINotFound
  { errors :: [Text]
  , message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON APINotFound where
  parseJSON = withObject "APINotFound" $ \o ->
    APINotFound
      <$> o .: "errors"
      <*> o .: "message"
      <*> o .: "url"

instance ToJSON APINotFound where
  toJSON = genericToJSON runOptions

data APINotFoundPayload = APINotFoundPayload
  { arpAction :: Text
  , arpRun :: APINotFound
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APINotFoundPayload where
  parseJSON = withObject "APINotFoundPayload" $ \o ->
    APINotFoundPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON APINotFoundPayload where
  toJSON = genericToJSON arpOptions
