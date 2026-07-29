{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.IssueTemplate
  ( IssueTemplate (..)
  , IssueTemplatePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.IssueFormField (IssueFormField)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data IssueTemplate = IssueTemplate
  { about :: Text
  , body :: [IssueFormField]
  , content :: Text
  , fileName :: Text
  , labels :: [Text]
  , name :: Text
  , ref :: Text
  , title :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON IssueTemplate where
  parseJSON = withObject "IssueTemplate" $ \o ->
    IssueTemplate
      <$> o .: "about"
      <*> o .: "body"
      <*> o .: "content"
      <*> o .: "file_name"
      <*> o .: "labels"
      <*> o .: "name"
      <*> o .: "ref"
      <*> o .: "title"

instance ToJSON IssueTemplate where
  toJSON = genericToJSON runOptions

data IssueTemplatePayload = IssueTemplatePayload
  { arpAction :: Text
  , arpRun :: IssueTemplate
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IssueTemplatePayload where
  parseJSON = withObject "IssueTemplatePayload" $ \o ->
    IssueTemplatePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON IssueTemplatePayload where
  toJSON = genericToJSON arpOptions
