{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.AnnotatedTagObject
  ( AnnotatedTagObject (..)
  , AnnotatedTagObjectPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data AnnotatedTagObject = AnnotatedTagObject
  { sha :: Text
  , aType :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON AnnotatedTagObject where
  parseJSON = withObject "AnnotatedTagObject" $ \o ->
    AnnotatedTagObject
      <$> o .: "sha"
      <*> o .: "type"
      <*> o .: "url"

instance ToJSON AnnotatedTagObject where
  toJSON = genericToJSON runOptions

data AnnotatedTagObjectPayload = AnnotatedTagObjectPayload
  { arpAction :: Text
  , arpRun :: AnnotatedTagObject
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON AnnotatedTagObjectPayload where
  parseJSON = withObject "AnnotatedTagObjectPayload" $ \o ->
    AnnotatedTagObjectPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON AnnotatedTagObjectPayload where
  toJSON = genericToJSON arpOptions
