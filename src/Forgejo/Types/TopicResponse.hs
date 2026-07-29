{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.TopicResponse
  ( TopicResponse (..)
  , TopicResponsePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data TopicResponse = TopicResponse
  { created :: UTCTime
  , id :: Int
  , repoCount :: Int
  , topicName :: Text
  , updated :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON TopicResponse where
  parseJSON = withObject "TopicResponse" $ \o ->
    TopicResponse
      <$> o .: "created"
      <*> o .: "id"
      <*> o .: "repo_count"
      <*> o .: "topic_name"
      <*> o .: "updated"

instance ToJSON TopicResponse where
  toJSON = genericToJSON runOptions

data TopicResponsePayload = TopicResponsePayload
  { arpAction :: Text
  , arpRun :: TopicResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON TopicResponsePayload where
  parseJSON = withObject "TopicResponsePayload" $ \o ->
    TopicResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON TopicResponsePayload where
  toJSON = genericToJSON arpOptions
