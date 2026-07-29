{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateReleaseOption
  ( CreateReleaseOption (..)
  , CreateReleaseOptionPayload (..)
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
  { body :: Text
  , draft :: Bool
  , hideArchiveLinks :: Bool
  , name :: Text
  , prerelease :: Bool
  , tagName :: Text
  , targetComitish :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateReleaseOption where
  parseJSON = withObject "CreateReleaseOption" $ \o ->
    CreateReleaseOption
      <$> o .: "body"
      <*> o .: "draft"
      <*> o .: "hide_archive_links"
      <*> o .: "name"
      <*> o .: "prerelease"
      <*> o .: "tag_name"
      <*> o .: "target_commitish"

instance ToJSON CreateReleaseOption where
  toJSON = genericToJSON runOptions

data CreateReleaseOptionPayload = CreateReleaseOptionPayload
  { arpAction :: Text
  , arpRun :: CreateReleaseOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateReleaseOptionPayload where
  parseJSON = withObject "CreateReleaseOptionPayload" $ \o ->
    CreateReleaseOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateReleaseOptionPayload where
  toJSON = genericToJSON arpOptions
