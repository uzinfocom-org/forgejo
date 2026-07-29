{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateFileOptions
  ( CreateFileOptions (..)
  , CreateFileOptionsPayload (..)
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

data CreateFileOptions = CreateFileOptions
  { author :: Identity
  , branch :: Text
  , committer :: Identity
  , content :: Text
  , dates :: CommitDateOptions
  , message :: Text
  , newBranch :: Text
  , signoff :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateFileOptions where
  parseJSON = withObject "CreateFileOptions" $ \o ->
    CreateFileOptions
      <$> o .: "author"
      <*> o .: "branch"
      <*> o .: "committer"
      <*> o .: "content"
      <*> o .: "dates"
      <*> o .: "message"
      <*> o .: "new_branch"
      <*> o .: "signoff"

instance ToJSON CreateFileOptions where
  toJSON = genericToJSON runOptions

data CreateFileOptionsPayload = CreateFileOptionsPayload
  { arpAction :: Text
  , arpRun :: CreateFileOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateFileOptionsPayload where
  parseJSON = withObject "CreateFileOptionsPayload" $ \o ->
    CreateFileOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateFileOptionsPayload where
  toJSON = genericToJSON arpOptions
