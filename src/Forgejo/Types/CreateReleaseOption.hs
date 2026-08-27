{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateReleaseOption
  ( CreateReleaseOption (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateReleaseOption = CreateReleaseOption
  { body :: Maybe Text
  , draft :: Maybe Bool
  , hideArchiveLinks :: Maybe Bool
  , name :: Maybe Text
  , prerelease :: Maybe Bool
  , tagName :: Text
  , targetComitish :: Maybe Text
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreateReleaseOption where
  toJSON = genericToJSON runOptions
