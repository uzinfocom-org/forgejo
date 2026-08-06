{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateMilestoneOption
  ( CreateMilestoneOption (..)
  , CreateMilestoneOptionPayload (..)
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

data State = Open | Closed
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data CreateMilestoneOption = CreateMilestoneOption
  { description :: Text
  , dueOn :: UTCTime
  , state :: State
  , title :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateMilestoneOption where
  parseJSON = withObject "CreateMilestoneOption" $ \o ->
    CreateMilestoneOption
      <$> o .: "description"
      <*> o .: "due_on"
      <*> o .: "state"
      <*> o .: "title"

instance ToJSON CreateMilestoneOption where
  toJSON = genericToJSON runOptions

data CreateMilestoneOptionPayload = CreateMilestoneOptionPayload
  { arpAction :: Text
  , arpRun :: CreateMilestoneOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateMilestoneOptionPayload where
  parseJSON = withObject "CreateMilestoneOptionPayload" $ \o ->
    CreateMilestoneOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateMilestoneOptionPayload where
  toJSON = genericToJSON arpOptions
