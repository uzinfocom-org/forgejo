{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APINotFound
  ( APINotFound (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APINotFound = APINotFound
  { errors :: [Text]
  , message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APINotFound where
  parseJSON = withObject "APINotFound" $ \o ->
    APINotFound
      <$> o .: "errors"
      <*> o .: "message"
      <*> o .: "url"

instance ToJSON APINotFound where
  toJSON = genericToJSON runOptions
