{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CommitAffectedFiles
  ( CommitAffectedFiles (..)
  , CommitAffectedFilesPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CommitAffectedFiles = CommitAffectedFiles
  { filename :: Text
  , status :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CommitAffectedFiles where
  parseJSON = withObject "CommitAffectedFiles" $ \o ->
    CommitAffectedFiles
      <$> o .: "filename"
      <*> o .: "status"

instance ToJSON CommitAffectedFiles where
  toJSON = genericToJSON runOptions

data CommitAffectedFilesPayload = CommitAffectedFilesPayload
  { arpAction :: Text
  , arpRun :: CommitAffectedFiles
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CommitAffectedFilesPayload where
  parseJSON = withObject "CommitAffectedFilesPayload" $ \o ->
    CommitAffectedFilesPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CommitAffectedFilesPayload where
  toJSON = genericToJSON arpOptions
