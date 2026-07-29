{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.NoteOptions
  ( NoteOptions (..)
  , NoteOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data NoteOptions = NoteOptions
  { message :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON NoteOptions where
  parseJSON = withObject "NoteOptions" $ \o ->
    NoteOptions
      <$> o .: "message"

instance ToJSON NoteOptions where
  toJSON = genericToJSON runOptions

data NoteOptionsPayload = NoteOptionsPayload
  { arpAction :: Text
  , arpRun :: NoteOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NoteOptionsPayload where
  parseJSON = withObject "NoteOptionsPayload" $ \o ->
    NoteOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NoteOptionsPayload where
  toJSON = genericToJSON arpOptions
