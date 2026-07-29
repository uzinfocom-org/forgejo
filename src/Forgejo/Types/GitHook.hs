{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GitHook
  ( GitHook (..)
  , GitHookPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GitHook = GitHook
  { content :: Text
  , isActive :: Bool
  , name :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GitHook where
  parseJSON = withObject "GitHook" $ \o ->
    GitHook
      <$> o .: "content"
      <*> o .: "is_active"
      <*> o .: "name"

instance ToJSON GitHook where
  toJSON = genericToJSON runOptions

data GitHookPayload = GitHookPayload
  { arpAction :: Text
  , arpRun :: GitHook
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GitHookPayload where
  parseJSON = withObject "GitHookPayload" $ \o ->
    GitHookPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GitHookPayload where
  toJSON = genericToJSON arpOptions
