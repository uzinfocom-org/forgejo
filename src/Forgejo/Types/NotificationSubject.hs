{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.NotificationSubject
  ( NotificationSubject (..)
  , NotificationSubjectPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data NotificationSubject = NotificationSubject
  { htmlUrl :: Text
  , latestCommentHtmlUrl :: Text
  , latestCommentUrl :: Text
  , state :: Text
  , title :: Text
  , nsType :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON NotificationSubject where
  parseJSON = withObject "NotificationSubject" $ \o ->
    NotificationSubject
      <$> o .: "html_url"
      <*> o .: "latest_comment_html_url"
      <*> o .: "latest_comment_url"
      <*> o .: "state"
      <*> o .: "title"
      <*> o .: "type"
      <*> o .: "url"

instance ToJSON NotificationSubject where
  toJSON = genericToJSON runOptions

data NotificationSubjectPayload = NotificationSubjectPayload
  { arpAction :: Text
  , arpRun :: NotificationSubject
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NotificationSubjectPayload where
  parseJSON = withObject "NotificationSubjectPayload" $ \o ->
    NotificationSubjectPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NotificationSubjectPayload where
  toJSON = genericToJSON arpOptions
