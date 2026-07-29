{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ListActionRunResponse
  ( ListActionRunResponse (..)
  , ListActionRunResponsePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.ActionRun (ActionRun)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data ListActionRunResponse = ListActionRunResponse
  { totalCount :: Int
  , workflowRuns :: [ActionRun]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ListActionRunResponse where
  parseJSON = withObject "ListActionRunResponse" $ \o ->
    ListActionRunResponse
      <$> o .: "total_count"
      <*> o .: "workflow_runs"

instance ToJSON ListActionRunResponse where
  toJSON = genericToJSON runOptions

data ListActionRunResponsePayload = ListActionRunResponsePayload
  { arpAction :: Text
  , arpRun :: ListActionRunResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ListActionRunResponsePayload where
  parseJSON = withObject "ListActionRunResponsePayload" $ \o ->
    ListActionRunResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ListActionRunResponsePayload where
  toJSON = genericToJSON arpOptions
