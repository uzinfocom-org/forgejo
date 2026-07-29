{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ActionRunJob
  ( ActionRunJob (..)
  , ActionRunJobPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arjpOptions :: Options
arjpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}

arjOptions :: Options
arjOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data ActionRunJob = ActionRunJob
  { arjAttempt :: Int
  , arjHandle :: Text
  , arjId :: Int
  , arjName :: Text
  , arjNeeds :: [Text]
  , arjOwnerId :: Int
  , arjRepoId :: Int
  , arjRunsOn :: [Text]
  , arjStatus :: Text
  , arjTaskId :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ActionRunJob where
  parseJSON = withObject "ActionRunJob" $ \o ->
    ActionRunJob
      <$> o .: "id"
      <*> o .: "attempt"
      <*> o .: "handle"
      <*> o .: "name"
      <*> o .: "needs"
      <*> o .: "owner_id"
      <*> o .: "repo_id"
      <*> o .: "runs_on"
      <*> o .: "status"
      <*> o .: "task_id"

instance ToJSON ActionRunJob where
  toJSON = genericToJSON arjOptions

data ActionRunJobPayload = ActionRunJobPayload
  { arjpAction :: Text
  , arjpRun :: ActionRunJob
  , arjpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ActionRunJobPayload where
  parseJSON = withObject "ActionRunJobPayload" $ \o ->
    ActionRunJobPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ActionRunJobPayload where
  toJSON = genericToJSON arjpOptions
