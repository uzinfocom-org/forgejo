{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.TagArchiveDownloadCount
  ( TagArchiveDownloadCount (..)
  , TagArchiveDownloadCountPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data TagArchiveDownloadCount = TagArchiveDownloadCount
  { tarGz :: Int
  , zip :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON TagArchiveDownloadCount where
  parseJSON = withObject "TagArchiveDownloadCount" $ \o ->
    TagArchiveDownloadCount
      <$> o .: "tar_gz"
      <*> o .: "zip"

instance ToJSON TagArchiveDownloadCount where
  toJSON = genericToJSON runOptions

data TagArchiveDownloadCountPayload = TagArchiveDownloadCountPayload
  { arpAction :: Text
  , arpRun :: TagArchiveDownloadCount
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON TagArchiveDownloadCountPayload where
  parseJSON = withObject "TagArchiveDownloadCountPayload" $ \o ->
    TagArchiveDownloadCountPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON TagArchiveDownloadCountPayload where
  toJSON = genericToJSON arpOptions
