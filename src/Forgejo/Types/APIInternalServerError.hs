{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIInternalServerError
  ( APIInternalServerError (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIInternalServerError = APIInternalServerError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIInternalServerError where
  parseJSON = withObject "APIInternalServerError" $ \o ->
    APIInternalServerError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIInternalServerError where
  toJSON = genericToJSON runOptions
