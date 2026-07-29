{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditReleaseOption
  ( EditReleaseOption (..)
  , EditReleaseOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditReleaseOption = EditReleaseOption
  { body :: Text
  , draft :: Bool
  , hideArchiveLinks :: Bool
  , name :: Text
  , prerelease :: Bool
  , tagName :: Text
  , targetCommitish :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditReleaseOption where
  parseJSON = withObject "EditReleaseOption" $ \o ->
    EditReleaseOption
      <$> o .: "body"
      <*> o .: "draft"
      <*> o .: "hide_archive_links"
      <*> o .: "name"
      <*> o .: "prerelease"
      <*> o .: "tag_name"
      <*> o .: "target_commitish"

instance ToJSON EditReleaseOption where
  toJSON = genericToJSON runOptions

data EditReleaseOptionPayload = EditReleaseOptionPayload
  { arpAction :: Text
  , arpRun :: EditReleaseOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditReleaseOptionPayload where
  parseJSON = withObject "EditReleaseOptionPayload" $ \o ->
    EditReleaseOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditReleaseOptionPayload where
  toJSON = genericToJSON arpOptions
