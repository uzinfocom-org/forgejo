{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ActionTaskResponse
  ( ActionTaskResponse (..)
  , ActionTaskResponsePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.ActionTask (ActionTask)
import GHC.Generics (Generic)

atrpOptions :: Options
atrpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

atrOptions :: Options
atrOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data ActionTaskResponse = ActionTaskResponse
  { atrTotalCount :: Int
  , atrWorkflowRuns :: [ActionTask]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ActionTaskResponse where
  parseJSON = withObject "ActionTaskResponse" $ \o ->
    ActionTaskResponse
      <$> o .: "total_count"
      <*> o .: "workflow_runs"

instance ToJSON ActionTaskResponse where
  toJSON = genericToJSON atrOptions

data ActionTaskResponsePayload = ActionTaskResponsePayload
  { arpAction :: Text
  , arpRun :: ActionTaskResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ActionTaskResponsePayload where
  parseJSON = withObject "ActionTaskResponsePayload" $ \o ->
    ActionTaskResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ActionTaskResponsePayload where
  toJSON = genericToJSON atrpOptions
