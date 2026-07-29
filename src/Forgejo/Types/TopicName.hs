{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.TopicName
  ( TopicName (..)
  , TopicNamePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data TopicName = TopicName
  { topics :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON TopicName where
  parseJSON = withObject "TopicName" $ \o ->
    TopicName
      <$> o .: "topics"

instance ToJSON TopicName where
  toJSON = genericToJSON runOptions

data TopicNamePayload = TopicNamePayload
  { arpAction :: Text
  , arpRun :: TopicName
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON TopicNamePayload where
  parseJSON = withObject "TopicNamePayload" $ \o ->
    TopicNamePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON TopicNamePayload where
  toJSON = genericToJSON arpOptions
