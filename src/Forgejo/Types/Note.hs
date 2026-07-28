{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Note
  ( Note (..)
  , NotePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.Commit (Commit)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Note = Note
  { commit :: Commit
  , message :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Note where
  parseJSON = withObject "Note" $ \o ->
    Note
      <$> o .: "commit"
      <*> o .: "message"

instance ToJSON Note where
  toJSON = genericToJSON runOptions

data NotePayload = NotePayload
  { arpAction :: Text
  , arpRun :: Note
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NotePayload where
  parseJSON = withObject "NotePayload" $ \o ->
    NotePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NotePayload where
  toJSON = genericToJSON arpOptions
