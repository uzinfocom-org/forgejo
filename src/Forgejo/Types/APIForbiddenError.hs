{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIForbiddenError
  ( APIForbiddenError (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIForbiddenError = APIForbiddenError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIForbiddenError where
  parseJSON = withObject "APIForbiddenError" $ \o ->
    APIForbiddenError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIForbiddenError where
  toJSON = genericToJSON runOptions
