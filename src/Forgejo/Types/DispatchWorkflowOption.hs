{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.DispatchWorkflowOption
  ( DispatchWorkflowOption (..)
  , DispatchWorkflowOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data DispatchWorkflowOption = DispatchWorkflowOption
  { inputs :: [Text] -- FIXME: example: {<*>: String}
  , ref :: Text
  , returnRunInfo :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON DispatchWorkflowOption where
  parseJSON = withObject "DispatchWorkflowOption" $ \o ->
    DispatchWorkflowOption
      <$> o .: "inputs"
      <*> o .: "ref"
      <*> o .: "return_run_info"

instance ToJSON DispatchWorkflowOption where
  toJSON = genericToJSON runOptions

data DispatchWorkflowOptionPayload = DispatchWorkflowOptionPayload
  { arpAction :: Text
  , arpRun :: DispatchWorkflowOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON DispatchWorkflowOptionPayload where
  parseJSON = withObject "DispatchWorkflowOptionPayload" $ \o ->
    DispatchWorkflowOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON DispatchWorkflowOptionPayload where
  toJSON = genericToJSON arpOptions
