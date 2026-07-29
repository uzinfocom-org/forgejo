{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ActionRun
  ( ActionRun (..)
  , ActionRunPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Common (RunId, ScheduleId, UserId)
import Forgejo.Types.Repository (Repository)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

arOptions :: Options
arOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

data ActionRun = ActionRun
  { arScheduleId :: ScheduleId
  , arApprovedBy :: UserId
  , arCommitSha :: Text
  , arCreated :: UTCTime
  , arDuration :: Int
  , arEvent :: Text
  , arEventPayload :: Text
  , arHtmlUrl :: Text
  , arId :: RunId
  , arIndexInRepo :: Int
  , arIsForkPullRequest :: Bool
  , arIsRefDeleted :: Bool
  , arNeedApproval :: Bool
  , arPrettyref :: Text
  , arRepository :: Repository
  , arStarted :: UTCTime
  , arStatus :: Text
  , arStopped :: UTCTime
  , arTitle :: Text
  , arTriggerEvent :: Text
  , arTriggerUser :: User
  , arUpdated :: UTCTime
  , arWorkflowId :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ActionRun where
  parseJSON = withObject "ActionRun" $ \o ->
    ActionRun
      <$> o .: "id"
      <*> o .: "title"
      <*> o .: "repository"
      <*> o .: "workflow_id"
      <*> o .: "index_in_repo"
      <*> o .: "trigger_user"
      <*> o .: "ScheduleID"
      <*> o .: "prettyref"
      <*> o .: "is_ref_deleted"
      <*> o .: "commit_sha"
      <*> o .: "is_fork_pull_request"
      <*> o .: "need_approval"
      <*> o .: "approved_by"
      <*> o .: "event"
      <*> o .: "event_payload"
      <*> o .: "trigger_event"
      <*> o .: "status"
      <*> o .: "started"
      <*> o .: "stopped"
      <*> o .: "created"
      <*> o .: "updated"
      <*> o .: "duration"
      <*> o .: "html_url"

instance ToJSON ActionRun where
  toJSON = genericToJSON arOptions

data ActionRunPayload = ActionRunPayload
  { arpAction :: Text
  , arpRun :: ActionRun
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ActionRunPayload where
  parseJSON = withObject "ActionRunPayload" $ \o ->
    ActionRunPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ActionRunPayload where
  toJSON = genericToJSON arpOptions
