{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditDeadlineOption
  ( EditDeadlineOption (..)
  , EditDeadlineOptionPayload (..)
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

data EditDeadlineOption = EditDeadlineOption
  { dueDate :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditDeadlineOption where
  parseJSON = withObject "EditDeadlineOption" $ \o ->
    EditDeadlineOption
      <$> o .: "due_date"

instance ToJSON EditDeadlineOption where
  toJSON = genericToJSON runOptions

data EditDeadlineOptionPayload = EditDeadlineOptionPayload
  { arpAction :: Text
  , arpRun :: EditDeadlineOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditDeadlineOptionPayload where
  parseJSON = withObject "EditDeadlineOptionPayload" $ \o ->
    EditDeadlineOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditDeadlineOptionPayload where
  toJSON = genericToJSON arpOptions
