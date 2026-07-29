{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.AddTimeOption
  ( AddTimeOption (..)
  , AddTimeOptionPayload (..)
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

data AddTimeOption = AddTimeOption
  { created :: UTCTime
  , time :: Int
  , userName :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON AddTimeOption where
  parseJSON = withObject "AddTimeOption" $ \o ->
    AddTimeOption
      <$> o .: "created"
      <*> o .: "time"
      <*> o .: "user_name"

instance ToJSON AddTimeOption where
  toJSON = genericToJSON runOptions

data AddTimeOptionPayload = AddTimeOptionPayload
  { arpAction :: Text
  , arpRun :: AddTimeOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON AddTimeOptionPayload where
  parseJSON = withObject "AddTimeOptionPayload" $ \o ->
    AddTimeOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON AddTimeOptionPayload where
  toJSON = genericToJSON arpOptions
