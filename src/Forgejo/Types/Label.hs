{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Label
  ( Label (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 1}

data Label = Label
  { lColor :: Text
  , lDescription :: Text
  , lExclusive :: Bool
  , lId :: Int
  , lIsArchived :: Bool
  , lName :: Text
  , lUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Label where
  parseJSON = withObject "Label" $ \o ->
    Label
      <$> o .: "color"
      <*> o .: "description"
      <*> o .: "exclusive"
      <*> o .: "id"
      <*> o .: "is_archived"
      <*> o .: "name"
      <*> o .: "url"

instance ToJSON Label where
  toJSON = genericToJSON runOptions
