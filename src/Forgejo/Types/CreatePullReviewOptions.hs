{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreatePullReviewOptions
  ( CreatePullReviewOptions (..)
  , CreatePullReviewOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.CreatePullReviewComment (CreatePullReviewComment)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreatePullReviewOptions = CreatePullReviewOptions
  { body :: Text
  , comments :: [CreatePullReviewComment]
  , commitId :: Text
  , event :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreatePullReviewOptions where
  parseJSON = withObject "CreatePullReviewOptions" $ \o ->
    CreatePullReviewOptions
      <$> o .: "body"
      <*> o .: "comments"
      <*> o .: "commit_id"
      <*> o .: "event"

instance ToJSON CreatePullReviewOptions where
  toJSON = genericToJSON runOptions

data CreatePullReviewOptionsPayload = CreatePullReviewOptionsPayload
  { arpAction :: Text
  , arpRun :: CreatePullReviewOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreatePullReviewOptionsPayload where
  parseJSON = withObject "CreatePullReviewOptionsPayload" $ \o ->
    CreatePullReviewOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreatePullReviewOptionsPayload where
  toJSON = genericToJSON arpOptions
