{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIValidationError
  ( APIValidationError (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIValidationError = APIValidationError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIValidationError where
  parseJSON = withObject "APIValidationError" $ \o ->
    APIValidationError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIValidationError where
  toJSON = genericToJSON runOptions
