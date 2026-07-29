{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.DispatchWorkflowRun
  ( DispatchWorkflowRun (..)
  , DispatchWorkflowRunPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data DispatchWorkflowRun = DispatchWorkflowRun
  { id :: Text
  , jobs :: [Text]
  , runNumber :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON DispatchWorkflowRun where
  parseJSON = withObject "DispatchWorkflowRun" $ \o ->
    DispatchWorkflowRun
      <$> o .: "id"
      <*> o .: "jobs"
      <*> o .: "run_number"

instance ToJSON DispatchWorkflowRun where
  toJSON = genericToJSON runOptions

data DispatchWorkflowRunPayload = DispatchWorkflowRunPayload
  { arpAction :: Text
  , arpRun :: DispatchWorkflowRun
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON DispatchWorkflowRunPayload where
  parseJSON = withObject "DispatchWorkflowRunPayload" $ \o ->
    DispatchWorkflowRunPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON DispatchWorkflowRunPayload where
  toJSON = genericToJSON arpOptions
