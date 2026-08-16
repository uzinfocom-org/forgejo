{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIRepoArchivedError
  ( APIRepoArchivedError (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIRepoArchivedError = APIRepoArchivedError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIRepoArchivedError where
  parseJSON = withObject "APIRepoArchivedError" $ \o ->
    APIRepoArchivedError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIRepoArchivedError where
  toJSON = genericToJSON runOptions
