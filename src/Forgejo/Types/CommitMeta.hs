{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CommitMeta
  ( CommitMeta (..)
  , CommitMetaPayload (..)
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

data CommitMeta = CommitMeta
  { created :: UTCTime
  , sha :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CommitMeta where
  parseJSON = withObject "CommitMeta" $ \o ->
    CommitMeta
      <$> o .: "created"
      <*> o .: "sha"
      <*> o .: "url"

instance ToJSON CommitMeta where
  toJSON = genericToJSON runOptions

data CommitMetaPayload = CommitMetaPayload
  { arpAction :: Text
  , arpRun :: CommitMeta
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CommitMetaPayload where
  parseJSON = withObject "CommitMetaPayload" $ \o ->
    CommitMetaPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CommitMetaPayload where
  toJSON = genericToJSON arpOptions
