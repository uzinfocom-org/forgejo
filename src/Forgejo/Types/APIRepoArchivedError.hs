{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIRepoArchivedError
  ( APIRepoArchivedError (..)
  , APIRepoArchivedErrorPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIRepoArchivedError = APIRepoArchivedError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON APIRepoArchivedError where
  parseJSON = withObject "APIRepoArchivedError" $ \o ->
    APIRepoArchivedError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIRepoArchivedError where
  toJSON = genericToJSON runOptions

data APIRepoArchivedErrorPayload = APIRepoArchivedErrorPayload
  { arpAction :: Text
  , arpRun :: APIRepoArchivedError
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIRepoArchivedErrorPayload where
  parseJSON = withObject "APIRepoArchivedErrorPayload" $ \o ->
    APIRepoArchivedErrorPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON APIRepoArchivedErrorPayload where
  toJSON = genericToJSON arpOptions
