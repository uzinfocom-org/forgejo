{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CommitUser
  ( CommitUser (..)
  , CommitUserPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CommitUser = CommitUser
  { date :: Text
  , email :: Text
  , name :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CommitUser where
  parseJSON = withObject "CommitUser" $ \o ->
    CommitUser
      <$> o .: "date"
      <*> o .: "email"
      <*> o .: "name"

instance ToJSON CommitUser where
  toJSON = genericToJSON runOptions

data CommitUserPayload = CommitUserPayload
  { arpAction :: Text
  , arpRun :: CommitUser
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CommitUserPayload where
  parseJSON = withObject "CommitUserPayload" $ \o ->
    CommitUserPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CommitUserPayload where
  toJSON = genericToJSON arpOptions
