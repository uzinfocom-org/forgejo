{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Release
  ( Release (..)
  , ReleasePayload (..)
  , HookReleaseAction (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, withText, genericToJSON)
import Data.Aeson qualified as AE
import Data.Aeson.Encoding qualified as AE
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Attachment (Attachment)
import Forgejo.Types.Common (ReleaseId)
import Forgejo.Types.Repository (Repository)
import Forgejo.Types.TagArchiveDownloadCount (TagArchiveDownloadCount)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

relOptions :: Options
relOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

rpOptions :: Options
rpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

data Release = Release
  { relId :: ReleaseId
  , relTagName :: Text
  , relTargetCommitish :: Text
  , relName :: Text
  , relBody :: Text
  , relUrl :: Text
  , relHtmlUrl :: Text
  , relTarballUrl :: Text
  , relZipballUrl :: Text
  , relHideArchiveLinks :: Bool
  , relUploadUrl :: Text
  , relDraft :: Bool
  , relPrerelease :: Bool
  , relCreatedAt :: UTCTime
  , relPublishedAt :: UTCTime
  , relAuthor :: Maybe User
  , relAssets :: [Attachment]
  , relArchiveDownlaodCount :: Maybe TagArchiveDownloadCount
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Release where
  parseJSON = genericParseJSON relOptions

instance ToJSON Release where
  toJSON = genericToJSON relOptions

data HookReleaseAction
  = RelPublished
  | RelUpdated
  | RelDeleted
  | RelUnknown Text
  deriving stock (Eq, Generic, Show)

instance FromJSON HookReleaseAction where
  parseJSON =
    withText "HookReleaseAction"
    $ pure . \case
      "published" -> RelPublished
      "updated" -> RelUpdated
      "deleted" -> RelDeleted
      x -> RelUnknown x

instance ToJSON HookReleaseAction where
  toJSON = AE.String . fromTaggedReleaseHook
  toEncoding = AE.text . fromTaggedReleaseHook

fromTaggedReleaseHook :: HookReleaseAction -> Text
fromTaggedReleaseHook = \case
  RelPublished -> "published"
  RelUpdated -> "updated"
  RelDeleted -> "deleted"
  RelUnknown t -> t

data ReleasePayload = ReleasePayload
  { rpAction :: HookReleaseAction
  , rpRelease :: Release
  , rpRepository :: Repository
  , rpSender :: User
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ReleasePayload where
  parseJSON = genericParseJSON rpOptions

instance ToJSON ReleasePayload where
  toJSON = genericToJSON rpOptions
