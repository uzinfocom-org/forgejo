{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PullRequestMeta
  ( PullRequestMeta (..)
  , PullRequestMetaPayload (..)
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

data PullRequestMeta = PullRequestMeta
  { draft :: Bool
  , htmlUrl :: Text
  , merged :: Bool
  , mergedAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PullRequestMeta where
  parseJSON = withObject "PullRequestMeta" $ \o ->
    PullRequestMeta
      <$> o .: "draft"
      <*> o .: "html_url"
      <*> o .: "merged"
      <*> o .: "merged_at"

instance ToJSON PullRequestMeta where
  toJSON = genericToJSON runOptions

data PullRequestMetaPayload = PullRequestMetaPayload
  { arpAction :: Text
  , arpRun :: PullRequestMeta
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PullRequestMetaPayload where
  parseJSON = withObject "PullRequestMetaPayload" $ \o ->
    PullRequestMetaPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PullRequestMetaPayload where
  toJSON = genericToJSON arpOptions
