{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Release
  ( Release (..)
  , ReleasePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Attachment (Attachment)
import Forgejo.Types.TagArchiveDownloadCount (TagArchiveDownloadCount)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Release = Release
  { archiveDownloadCount :: TagArchiveDownloadCount
  , assets :: [Attachment]
  , author :: User
  , body :: Text
  , createdAt :: UTCTime
  , draft :: Bool
  , hideArchiveLinks :: Bool
  , htmlUrl :: Text
  , id :: Int
  , name :: Text
  , prerelease :: Bool
  , publishedAt :: UTCTime
  , tagName :: Text
  , tarballUrl :: Text
  , targetCommitish :: Text
  , uploadUrl :: Text
  , url :: Text
  , zipballUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Release where
  parseJSON = withObject "Release" $ \o ->
    Release
      <$> o .: "archive_download_count"
      <*> o .: "assets"
      <*> o .: "author"
      <*> o .: "body"
      <*> o .: "created_at"
      <*> o .: "draft"
      <*> o .: "hide_archive_links"
      <*> o .: "html_url"
      <*> o .: "id"
      <*> o .: "name"
      <*> o .: "prerelease"
      <*> o .: "published_at"
      <*> o .: "tag_name"
      <*> o .: "tarball_url"
      <*> o .: "target_commitish"
      <*> o .: "upload_url"
      <*> o .: "url"
      <*> o .: "zipball_url"

instance ToJSON Release where
  toJSON = genericToJSON runOptions

data ReleasePayload = ReleasePayload
  { arpAction :: Text
  , arpRun :: Release
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ReleasePayload where
  parseJSON = withObject "ReleasePayload" $ \o ->
    ReleasePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ReleasePayload where
  toJSON = genericToJSON arpOptions
