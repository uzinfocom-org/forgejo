{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.IssueMeta
  ( IssueMeta (..)
  , IssueMetaPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data IssueMeta = IssueMeta
  { index :: Int
  , owner :: Text
  , repo :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON IssueMeta where
  parseJSON = withObject "IssueMeta" $ \o ->
    IssueMeta
      <$> o .: "index"
      <*> o .: "owner"
      <*> o .: "repo"

instance ToJSON IssueMeta where
  toJSON = genericToJSON runOptions

data IssueMetaPayload = IssueMetaPayload
  { arpAction :: Text
  , arpRun :: IssueMeta
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IssueMetaPayload where
  parseJSON = withObject "IssueMetaPayload" $ \o ->
    IssueMetaPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON IssueMetaPayload where
  toJSON = genericToJSON arpOptions
