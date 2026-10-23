{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.APIPreconditionFailed
  ( APIPreconditionFailed (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data APIPreconditionFailed = APIPreconditionFailed
  { message :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON APIPreconditionFailed where
  parseJSON = withObject "APIPreconditionFailed" $ \o ->
    APIPreconditionFailed
      <$> o .: "message"
      <*> o .: "url"

instance ToJSON APIPreconditionFailed where
  toJSON = genericToJSON runOptions
