{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.NotificationThread
  ( NotificationThread (..)
  , NotificationThreadPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.NotificationSubject (NotificationSubject)
import Forgejo.Types.Repository (Repository)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data NotificationThread = NotificationThread
  { id :: Int
  , pinned :: Bool
  , repository :: Repository
  , subject :: NotificationSubject
  , unread :: Bool
  , updatedAt :: UTCTime
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON NotificationThread where
  parseJSON = withObject "NotificationThread" $ \o ->
    NotificationThread
      <$> o .: "id"
      <*> o .: "pinned"
      <*> o .: "repository"
      <*> o .: "subject"
      <*> o .: "unread"
      <*> o .: "updated_at"
      <*> o .: "url"

instance ToJSON NotificationThread where
  toJSON = genericToJSON runOptions

data NotificationThreadPayload = NotificationThreadPayload
  { arpAction :: Text
  , arpRun :: NotificationThread
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NotificationThreadPayload where
  parseJSON = withObject "NotificationThreadPayload" $ \o ->
    NotificationThreadPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NotificationThreadPayload where
  toJSON = genericToJSON arpOptions
