{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.AnnotatedTag
  ( AnnotatedTag (..)
  , AnnotatedTagPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.AnnotatedTagObject (AnnotatedTagObject)
import Forgejo.Types.CommitUser (CommitUser)
import Forgejo.Types.PayloadCommitVerification (PayloadCommitVerification)
import Forgejo.Types.TagArchiveDownloadCount (TagArchiveDownloadCount)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data AnnotatedTag = AnnotatedTag
  { archiveDownloadCount :: TagArchiveDownloadCount
  , message :: Text
  , object :: AnnotatedTagObject
  , sha :: Text
  , tag :: Text
  , tagger :: CommitUser
  , url :: Text
  , verification :: PayloadCommitVerification
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON AnnotatedTag where
  parseJSON = withObject "AnnotatedTag" $ \o ->
    AnnotatedTag
      <$> o .: "archive_download_count"
      <*> o .: "message"
      <*> o .: "object"
      <*> o .: "sha"
      <*> o .: "tag"
      <*> o .: "tagger"
      <*> o .: "url"
      <*> o .: "verification"

instance ToJSON AnnotatedTag where
  toJSON = genericToJSON runOptions

data AnnotatedTagPayload = AnnotatedTagPayload
  { arpAction :: Text
  , arpRun :: AnnotatedTag
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON AnnotatedTagPayload where
  parseJSON = withObject "AnnotatedTagPayload" $ \o ->
    AnnotatedTagPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON AnnotatedTagPayload where
  toJSON = genericToJSON arpOptions
