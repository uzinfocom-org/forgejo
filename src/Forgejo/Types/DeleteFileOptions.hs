{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.DeleteFileOptions
  ( DeleteFileOptions (..)
  , DeleteFileOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.CommitDateOptions (CommitDateOptions)
import Forgejo.Types.Identity (Identity)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data DeleteFileOptions = DeleteFileOptions
  { author :: Identity
  , branch :: Text
  , committer :: Identity
  , dates :: CommitDateOptions
  , message :: Text
  , newBranch :: Text
  , sha :: Text
  , signoff :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON DeleteFileOptions where
  parseJSON = withObject "DeleteFileOptions" $ \o ->
    DeleteFileOptions
      <$> o .: "author"
      <*> o .: "branch"
      <*> o .: "committer"
      <*> o .: "dates"
      <*> o .: "message"
      <*> o .: "new_branch"
      <*> o .: "sha"
      <*> o .: "signoff"

instance ToJSON DeleteFileOptions where
  toJSON = genericToJSON runOptions

data DeleteFileOptionsPayload = DeleteFileOptionsPayload
  { arpAction :: Text
  , arpRun :: DeleteFileOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON DeleteFileOptionsPayload where
  parseJSON = withObject "DeleteFileOptionsPayload" $ \o ->
    DeleteFileOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON DeleteFileOptionsPayload where
  toJSON = genericToJSON arpOptions
