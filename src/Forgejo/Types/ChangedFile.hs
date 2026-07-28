{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ChangedFile
  ( ChangedFile (..)
  , ChangedFilePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data ChangedFile = ChangedFile
  { additions :: Int
  , changes :: Int
  , contentsUrl :: Text
  , deletions :: Int
  , filename :: Text
  , htmlUrl :: Text
  , previousFilename :: Text
  , rawUrl :: Text
  , status :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ChangedFile where
  parseJSON = withObject "ChangedFile" $ \o ->
    ChangedFile
      <$> o .: "additions"
      <*> o .: "changes"
      <*> o .: "contents_url"
      <*> o .: "deletions"
      <*> o .: "filename"
      <*> o .: "html_url"
      <*> o .: "previous_filename"
      <*> o .: "raw_url"
      <*> o .: "status"

instance ToJSON ChangedFile where
  toJSON = genericToJSON runOptions

data ChangedFilePayload = ChangedFilePayload
  { arpAction :: Text
  , arpRun :: ChangedFile
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ChangedFilePayload where
  parseJSON = withObject "ChangedFilePayload" $ \o ->
    ChangedFilePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ChangedFilePayload where
  toJSON = genericToJSON arpOptions
