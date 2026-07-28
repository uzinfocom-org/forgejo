{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.NotificationCount
  ( NotificationCount (..)
  , NotificationCountPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data NotificationCount = NotificationCount
  { new :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON NotificationCount where
  parseJSON = withObject "NotificationCount" $ \o ->
    NotificationCount
      <$> o .: "new"

instance ToJSON NotificationCount where
  toJSON = genericToJSON runOptions

data NotificationCountPayload = NotificationCountPayload
  { arpAction :: Text
  , arpRun :: NotificationCount
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NotificationCountPayload where
  parseJSON = withObject "NotificationCountPayload" $ \o ->
    NotificationCountPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NotificationCountPayload where
  toJSON = genericToJSON arpOptions
