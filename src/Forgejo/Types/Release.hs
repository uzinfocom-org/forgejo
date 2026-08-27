{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Release
  ( Release (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:), genericParseJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Attachment (Attachment)
import Forgejo.Types.TagArchiveDownloadCount (TagArchiveDownloadCount)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

rOptions :: Options
rOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 1}

data Release = Release
  { rArchiveDownloadCount :: TagArchiveDownloadCount
  , rAssets :: [Attachment]
  , rAuthor :: User
  , rBody :: Text
  , rCreatedAt :: UTCTime
  , rDraft :: Bool
  , rHideArchiveLinks :: Bool
  , rHtmlUrl :: Text
  , rId :: Int
  , rName :: Text
  , rPrerelease :: Bool
  , rPublishedAt :: UTCTime
  , rTagName :: Text
  , rTarballUrl :: Text
  , rTargetCommitish :: Text
  , rUploadUrl :: Text
  , rUrl :: Text
  , rZipballUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Release where
  parseJSON = genericParseJSON rOptions

instance ToJSON Release where
  toJSON = genericToJSON rOptions
