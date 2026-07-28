{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PayloadCommit
  ( PayloadCommit (..)
  , PayloadCommitPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.PayloadCommitVerification (PayloadCommitVerification)
import Forgejo.Types.PayloadUser (PayloadUser)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PayloadCommit = PayloadCommit
  { added :: [Text]
  , author :: PayloadUser
  , committer :: PayloadUser
  , id :: Text
  , message :: Text
  , modified :: [Text]
  , timestamp :: UTCTime
  , url :: Text
  , verification :: PayloadCommitVerification
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PayloadCommit where
  parseJSON = withObject "PayloadCommit" $ \o ->
    PayloadCommit
      <$> o .: "commit"
      <*> o .: "effective_PayloadCommit_protection_name"
      <*> o .: "enable_status_check"
      <*> o .: "name"
      <*> o .: "protected"
      <*> o .: "required_approvals"
      <*> o .: "status_check_contexts"
      <*> o .: "user_can_merge"
      <*> o .: "user_can_push"

instance ToJSON PayloadCommit where
  toJSON = genericToJSON runOptions

data PayloadCommitPayload = PayloadCommitPayload
  { arpAction :: Text
  , arpRun :: PayloadCommit
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PayloadCommitPayload where
  parseJSON = withObject "PayloadCommitPayload" $ \o ->
    PayloadCommitPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PayloadCommitPayload where
  toJSON = genericToJSON arpOptions
