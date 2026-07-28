{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.SearchResults
  ( SearchResults (..)
  , SearchResultsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.Repository (Repository)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data SearchResults = SearchResults
  { srData :: [Repository]
  , ok :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON SearchResults where
  parseJSON = withObject "SearchResults" $ \o ->
    SearchResults
      <$> o .: "data"
      <*> o .: "ok"

instance ToJSON SearchResults where
  toJSON = genericToJSON runOptions

data SearchResultsPayload = SearchResultsPayload
  { arpAction :: Text
  , arpRun :: SearchResults
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON SearchResultsPayload where
  parseJSON = withObject "SearchResultsPayload" $ \o ->
    SearchResultsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON SearchResultsPayload where
  toJSON = genericToJSON arpOptions
