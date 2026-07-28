{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.SubmitPullReviewOptions
  ( SubmitPullReviewOptions (..)
  , SubmitPullReviewOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data SubmitPullReviewOptions = SubmitPullReviewOptions
  { body :: Text
  , event :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON SubmitPullReviewOptions where
  parseJSON = withObject "SubmitPullReviewOptions" $ \o ->
    SubmitPullReviewOptions
      <$> o .: "body"
      <*> o .: "event"

instance ToJSON SubmitPullReviewOptions where
  toJSON = genericToJSON runOptions

data SubmitPullReviewOptionsPayload = SubmitPullReviewOptionsPayload
  { arpAction :: Text
  , arpRun :: SubmitPullReviewOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON SubmitPullReviewOptionsPayload where
  parseJSON = withObject "SubmitPullReviewOptionsPayload" $ \o ->
    SubmitPullReviewOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON SubmitPullReviewOptionsPayload where
  toJSON = genericToJSON arpOptions
