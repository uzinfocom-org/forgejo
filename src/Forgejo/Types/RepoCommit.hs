{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RepoCommit
  ( RepoCommit (..)
  , RepoCommitPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.CommitMeta (CommitMeta)
import Forgejo.Types.CommitUser (CommitUser)
import Forgejo.Types.PayloadCommitVerification (PayloadCommitVerification)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RepoCommit = RepoCommit
  { author :: CommitUser
  , committer :: CommitUser
  , message :: Text
  , tree :: CommitMeta
  , url :: Text
  , verification :: PayloadCommitVerification
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RepoCommit where
  parseJSON = withObject "RepoCommit" $ \o ->
    RepoCommit
      <$> o .: "author"
      <*> o .: "committer"
      <*> o .: "message"
      <*> o .: "tree"
      <*> o .: "url"
      <*> o .: "verification"

instance ToJSON RepoCommit where
  toJSON = genericToJSON runOptions

data RepoCommitPayload = RepoCommitPayload
  { arpAction :: Text
  , arpRun :: RepoCommit
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RepoCommitPayload where
  parseJSON = withObject "RepoCommitPayload" $ \o ->
    RepoCommitPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RepoCommitPayload where
  toJSON = genericToJSON arpOptions
