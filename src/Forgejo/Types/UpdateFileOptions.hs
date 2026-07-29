{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.UpdateFileOptions
  ( UpdateFileOptions (..)
  , UpdateFileOptionsPayload (..)
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

data UpdateFileOptions = UpdateFileOptions
  { author :: Identity
  , branch :: Text
  , committer :: Identity
  , content :: Text -- Must be base64 encoded
  , dates :: CommitDateOptions
  , fromPath :: Text
  , message :: Text
  , newBranch :: Text
  , sha :: Text
  , signoff :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON UpdateFileOptions where
  parseJSON = withObject "UpdateFileOptions" $ \o ->
    UpdateFileOptions
      <$> o .: "author"
      <*> o .: "branch"
      <*> o .: "committer"
      <*> o .: "content"
      <*> o .: "dates"
      <*> o .: "from_path"
      <*> o .: "message"
      <*> o .: "new_branch"
      <*> o .: "sha"
      <*> o .: "signoff"

instance ToJSON UpdateFileOptions where
  toJSON = genericToJSON runOptions

data UpdateFileOptionsPayload = UpdateFileOptionsPayload
  { arpAction :: Text
  , arpRun :: UpdateFileOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON UpdateFileOptionsPayload where
  parseJSON = withObject "UpdateFileOptionsPayload" $ \o ->
    UpdateFileOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON UpdateFileOptionsPayload where
  toJSON = genericToJSON arpOptions
