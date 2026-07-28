{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreatePullReviewComment
  ( CreatePullReviewComment (..)
  , CreatePullReviewCommentPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreatePullReviewComment = CreatePullReviewComment
  { body :: Text
  , newPosition :: Int
  , oldPosition :: Int
  , path :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreatePullReviewComment where
  parseJSON = withObject "CreatePullReviewComment" $ \o ->
    CreatePullReviewComment
      <$> o .: "body"
      <*> o .: "new_position"
      <*> o .: "old_position"
      <*> o .: "path"

instance ToJSON CreatePullReviewComment where
  toJSON = genericToJSON runOptions

data CreatePullReviewCommentPayload = CreatePullReviewCommentPayload
  { arpAction :: Text
  , arpRun :: CreatePullReviewComment
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreatePullReviewCommentPayload where
  parseJSON = withObject "CreatePullReviewCommentPayload" $ \o ->
    CreatePullReviewCommentPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreatePullReviewCommentPayload where
  toJSON = genericToJSON arpOptions
