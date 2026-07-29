{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreatePullReviewCommentOptions
  ( CreatePullReviewCommentOptions (..)
  , CreatePullReviewCommentOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreatePullReviewCommentOptions = CreatePullReviewCommentOptions
  { body :: Text
  , newPosition :: Int
  , oldPosition :: Int
  , path :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreatePullReviewCommentOptions where
  parseJSON = withObject "CreatePullReviewCommentOptions" $ \o ->
    CreatePullReviewCommentOptions
      <$> o .: "body"
      <*> o .: "new_position"
      <*> o .: "old_position"
      <*> o .: "path"

instance ToJSON CreatePullReviewCommentOptions where
  toJSON = genericToJSON runOptions

data CreatePullReviewCommentOptionsPayload = CreatePullReviewCommentOptionsPayload
  { arpAction :: Text
  , arpRun :: CreatePullReviewCommentOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreatePullReviewCommentOptionsPayload where
  parseJSON = withObject "CreatePullReviewCommentOptionsPayload" $ \o ->
    CreatePullReviewCommentOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreatePullReviewCommentOptionsPayload where
  toJSON = genericToJSON arpOptions
