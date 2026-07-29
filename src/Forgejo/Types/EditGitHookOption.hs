{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditGitHookOption
  ( EditGitHookOption (..)
  , EditGitHookOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditGitHookOption = EditGitHookOption
  { content :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditGitHookOption where
  parseJSON = withObject "EditGitHookOption" $ \o ->
    EditGitHookOption
      <$> o .: "content"

instance ToJSON EditGitHookOption where
  toJSON = genericToJSON runOptions

data EditGitHookOptionPayload = EditGitHookOptionPayload
  { arpAction :: Text
  , arpRun :: EditGitHookOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditGitHookOptionPayload where
  parseJSON = withObject "EditGitHookOptionPayload" $ \o ->
    EditGitHookOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditGitHookOptionPayload where
  toJSON = genericToJSON arpOptions
