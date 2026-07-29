{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GeneralRepoOption
  ( GeneralRepoOption (..)
  , GeneralRepoOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GeneralRepoOption = GeneralRepoOption
  { avatar :: Bool
  , defaultBranch :: Text
  , description :: Text
  , gitContent :: Bool
  , gitHooks :: Bool
  , labels :: Bool
  , name :: Text
  , owner :: Text
  , private :: Bool
  , protectedBranch :: Bool
  , topics :: Bool
  , webhooks :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GeneralRepoOption where
  parseJSON = withObject "GeneralRepoOption" $ \o ->
    GeneralRepoOption
      <$> o .: "avatar"
      <*> o .: "default_branch"
      <*> o .: "description"
      <*> o .: "git_content"
      <*> o .: "git_hooks"
      <*> o .: "labels"
      <*> o .: "name"
      <*> o .: "owner"
      <*> o .: "private"
      <*> o .: "protected_branch"
      <*> o .: "topics"
      <*> o .: "webhooks"

instance ToJSON GeneralRepoOption where
  toJSON = genericToJSON runOptions

data GeneralRepoOptionPayload = GeneralRepoOptionPayload
  { arpAction :: Text
  , arpRun :: GeneralRepoOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GeneralRepoOptionPayload where
  parseJSON = withObject "GeneralRepoOptionPayload" $ \o ->
    GeneralRepoOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GeneralRepoOptionPayload where
  toJSON = genericToJSON arpOptions
