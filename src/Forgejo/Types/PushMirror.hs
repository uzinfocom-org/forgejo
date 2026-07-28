{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PushMirror
  ( PushMirror (..)
  , PushMirrorPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PushMirror = PushMirror
  { branchFilter :: Text
  , created :: UTCTime
  , lastError :: Text
  , lastUpdate :: UTCTime
  , publicKey :: Text
  , remoteAddress :: Text
  , remoteName :: Text
  , syncOnCommit :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PushMirror where
  parseJSON = withObject "PushMirror" $ \o ->
    PushMirror
      <$> o .: "branch_filter"
      <*> o .: "created"
      <*> o .: "last_error"
      <*> o .: "last_update"
      <*> o .: "public_key"
      <*> o .: "remote_address"
      <*> o .: "remote_name"
      <*> o .: "sync_on_commit"

instance ToJSON PushMirror where
  toJSON = genericToJSON runOptions

data PushMirrorPayload = PushMirrorPayload
  { arpAction :: Text
  , arpRun :: PushMirror
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PushMirrorPayload where
  parseJSON = withObject "PushMirrorPayload" $ \o ->
    PushMirrorPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PushMirrorPayload where
  toJSON = genericToJSON arpOptions
