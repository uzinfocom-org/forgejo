{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditMilestoneOption
  ( EditMilestoneOption (..)
  , EditMilestoneOptionPayload (..)
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

data EditMilestoneOption = EditMilestoneOption
  { description :: Text
  , dueOn :: UTCTime
  , state :: Text
  , title :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditMilestoneOption where
  parseJSON = withObject "EditMilestoneOption" $ \o ->
    EditMilestoneOption
      <$> o .: "description"
      <*> o .: "due_on"
      <*> o .: "state"
      <*> o .: "title"

instance ToJSON EditMilestoneOption where
  toJSON = genericToJSON runOptions

data EditMilestoneOptionPayload = EditMilestoneOptionPayload
  { arpAction :: Text
  , arpRun :: EditMilestoneOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditMilestoneOptionPayload where
  parseJSON = withObject "EditMilestoneOptionPayload" $ \o ->
    EditMilestoneOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditMilestoneOptionPayload where
  toJSON = genericToJSON arpOptions
