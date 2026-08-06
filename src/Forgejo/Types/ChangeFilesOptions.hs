{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ChangeFilesOptions
  ( ChangeFilesOptions (..)
  , ChangeFilesOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.ChangeFileOperation (ChangeFileOperation)
import Forgejo.Types.CommitDateOptions (CommitDateOptions)
import Forgejo.Types.Identity (Identity)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Operation = Create | Update | Delete
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data ChangeFilesOptions = ChangeFilesOptions
  { author :: Identity
  , branch :: Text
  , committer :: Identity
  , dates :: CommitDateOptions
  , files :: [ChangeFileOperation]
  , message :: Text
  , newBranch :: Text
  , signoff :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ChangeFilesOptions where
  parseJSON = withObject "ChangeFilesOptions" $ \o ->
    ChangeFilesOptions
      <$> o .: "author"
      <*> o .: "branch"
      <*> o .: "committer"
      <*> o .: "dates"
      <*> o .: "files"
      <*> o .: "message"
      <*> o .: "new_branch"
      <*> o .: "signoff"

instance ToJSON ChangeFilesOptions where
  toJSON = genericToJSON runOptions

data ChangeFilesOptionsPayload = ChangeFilesOptionsPayload
  { arpAction :: Text
  , arpRun :: ChangeFilesOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ChangeFilesOptionsPayload where
  parseJSON = withObject "ChangeFilesOptionsPayload" $ \o ->
    ChangeFilesOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ChangeFilesOptionsPayload where
  toJSON = genericToJSON arpOptions
