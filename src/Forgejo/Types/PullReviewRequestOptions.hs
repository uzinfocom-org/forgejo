{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PullReviewRequestOptions
  ( PullReviewRequestOptions (..)
  , PullReviewRequestOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PullReviewRequestOptions = PullReviewRequestOptions
  { reviewers :: [Text]
  , teamReviewers :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PullReviewRequestOptions where
  parseJSON = withObject "PullReviewRequestOptions" $ \o ->
    PullReviewRequestOptions
      <$> o .: "reviewers"
      <*> o .: "team_reviewers"

instance ToJSON PullReviewRequestOptions where
  toJSON = genericToJSON runOptions

data PullReviewRequestOptionsPayload = PullReviewRequestOptionsPayload
  { arpAction :: Text
  , arpRun :: PullReviewRequestOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PullReviewRequestOptionsPayload where
  parseJSON = withObject "PullReviewRequestOptionsPayload" $ \o ->
    PullReviewRequestOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PullReviewRequestOptionsPayload where
  toJSON = genericToJSON arpOptions
