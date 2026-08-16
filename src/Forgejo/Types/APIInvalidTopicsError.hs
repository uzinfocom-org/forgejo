{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIInvalidTopicsError
  ( APIInvalidTopicsError (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIInvalidTopicsError = APIInvalidTopicsError
  { invalidTopics :: [Text]
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIInvalidTopicsError where
  parseJSON = withObject "APIInvalidTopicsError" $ \o ->
    APIInvalidTopicsError
      <$> o .: "invalidTopics"
      <*> o .: "url"

instance ToJSON APIInvalidTopicsError where
  toJSON = genericToJSON runOptions
