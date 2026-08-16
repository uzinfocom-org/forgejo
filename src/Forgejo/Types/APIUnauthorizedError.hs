{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIUnauthorizedError
  ( APIUnauthorizedError (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIUnauthorizedError = APIUnauthorizedError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIUnauthorizedError where
  parseJSON = withObject "APIUnauthorizedError" $ \o ->
    APIUnauthorizedError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIUnauthorizedError where
  toJSON = genericToJSON runOptions
