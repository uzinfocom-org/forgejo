{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RepoTopicOptions
  ( RepoTopicOptions (..)
  , RepoTopicOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RepoTopicOptions = RepoTopicOptions
  { topics :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RepoTopicOptions where
  parseJSON = withObject "RepoTopicOptions" $ \o ->
    RepoTopicOptions
      <$> o .: "topics"

instance ToJSON RepoTopicOptions where
  toJSON = genericToJSON runOptions

data RepoTopicOptionsPayload = RepoTopicOptionsPayload
  { arpAction :: Text
  , arpRun :: RepoTopicOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RepoTopicOptionsPayload where
  parseJSON = withObject "RepoTopicOptionsPayload" $ \o ->
    RepoTopicOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RepoTopicOptionsPayload where
  toJSON = genericToJSON arpOptions
