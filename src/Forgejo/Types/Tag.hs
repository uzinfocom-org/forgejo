{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Tag
  ( Tag (..)
  , TagPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.TagArchiveDownloadCount (TagArchiveDownloadCount)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Tag = Tag
  { archiveDownloadCount :: TagArchiveDownloadCount
  , id :: Text
  , message :: Text
  , name :: Text
  , tarballUrl :: Text
  , zipballUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Tag where
  parseJSON = withObject "Tag" $ \o ->
    Tag
      <$> o .: "archive_download_count"
      <*> o .: "id"
      <*> o .: "message"
      <*> o .: "name"
      <*> o .: "tarball_url"
      <*> o .: "zipball_url"

instance ToJSON Tag where
  toJSON = genericToJSON runOptions

data TagPayload = TagPayload
  { arpAction :: Text
  , arpRun :: Tag
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON TagPayload where
  parseJSON = withObject "TagPayload" $ \o ->
    TagPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON TagPayload where
  toJSON = genericToJSON arpOptions
