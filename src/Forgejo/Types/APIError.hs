{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIError
  ( APIError (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIError = APIError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIError where
  parseJSON = withObject "APIError" $ \o ->
    APIError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIError where
  toJSON = genericToJSON runOptions
