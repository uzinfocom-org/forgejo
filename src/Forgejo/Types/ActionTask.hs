{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ActionTask
  ( ActionTask (..)
  , ActionTaskPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

atpOptions :: Options
atpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

atOptions :: Options
atOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

data ActionTask = ActionTask
  { atCreatedAt :: UTCTime
  , atDisplayTitle :: Text
  , atEvent :: Text
  , atHeadBranch :: Text
  , atHeadSha :: Text
  , atId :: Int
  , atName :: Text
  , atRunNumber :: Int
  , atStatus :: Text
  , atUpdatedAt :: UTCTime
  , atUrl :: Text
  , atWorkflowId :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ActionTask where
  parseJSON = withObject "ActionTask" $ \o ->
    ActionTask
      <$> o .: "created_at"
      <*> o .: "display_title"
      <*> o .: "event"
      <*> o .: "head_branch"
      <*> o .: "head_sha"
      <*> o .: "id"
      <*> o .: "name"
      <*> o .: "run_number"
      <*> o .: "status"
      <*> o .: "updated_at"
      <*> o .: "url"
      <*> o .: "workflow_id"

instance ToJSON ActionTask where
  toJSON = genericToJSON atOptions

data ActionTaskPayload = ActionTaskPayload
  { arpAction :: Text
  , arpRun :: ActionTask
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ActionTaskPayload where
  parseJSON = withObject "ActionTaskPayload" $ \o ->
    ActionTaskPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ActionTaskPayload where
  toJSON = genericToJSON atpOptions
