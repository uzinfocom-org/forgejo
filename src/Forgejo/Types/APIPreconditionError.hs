{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIPreconditionError
  ( APIPreconditionError (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIPreconditionError = APIPreconditionError
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIPreconditionError where
  parseJSON = withObject "APIPreconditionError" $ \o ->
    APIPreconditionError
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIPreconditionError where
  toJSON = genericToJSON runOptions
