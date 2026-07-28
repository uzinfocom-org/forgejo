{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.MarkdownOption
  ( MarkdownOption (..)
  , MarkdownOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data MarkdownOption = MarkdownOption
  { context :: Text
  , mode :: Text
  , text :: Text
  , wiki :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON MarkdownOption where
  parseJSON = withObject "MarkdownOption" $ \o ->
    MarkdownOption
      <$> o .: "Context"
      <*> o .: "Mode"
      <*> o .: "Text"
      <*> o .: "Wiki"

instance ToJSON MarkdownOption where
  toJSON = genericToJSON runOptions

data MarkdownOptionPayload = MarkdownOptionPayload
  { arpAction :: Text
  , arpRun :: MarkdownOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON MarkdownOptionPayload where
  parseJSON = withObject "MarkdownOptionPayload" $ \o ->
    MarkdownOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON MarkdownOptionPayload where
  toJSON = genericToJSON arpOptions
