{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.WikiCommit
  ( WikiCommit (..)
  , WikiCommitPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.CommitUser (CommitUser)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data WikiCommit = WikiCommit
  { author :: CommitUser
  , committer :: CommitUser
  , message :: Text
  , sha :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON WikiCommit where
  parseJSON = withObject "WikiCommit" $ \o ->
    WikiCommit
      <$> o .: "author"
      <*> o .: "committer"
      <*> o .: "message"
      <*> o .: "sha"

instance ToJSON WikiCommit where
  toJSON = genericToJSON runOptions

data WikiCommitPayload = WikiCommitPayload
  { arpAction :: Text
  , arpRun :: WikiCommit
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON WikiCommitPayload where
  parseJSON = withObject "WikiCommitPayload" $ \o ->
    WikiCommitPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON WikiCommitPayload where
  toJSON = genericToJSON arpOptions
