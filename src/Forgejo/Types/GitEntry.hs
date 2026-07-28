{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GitEntry
  ( GitEntry (..)
  , GitEntryPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GitEntry = GitEntry
  { mode :: Text
  , path :: Text
  , sha :: Text
  , size :: Int
  , geType :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GitEntry where
  parseJSON = withObject "GitEntry" $ \o ->
    GitEntry
      <$> o .: "mode"
      <*> o .: "path"
      <*> o .: "sha"
      <*> o .: "size"
      <*> o .: "type"
      <*> o .: "url"

instance ToJSON GitEntry where
  toJSON = genericToJSON runOptions

data GitEntryPayload = GitEntryPayload
  { arpAction :: Text
  , arpRun :: GitEntry
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GitEntryPayload where
  parseJSON = withObject "GitEntryPayload" $ \o ->
    GitEntryPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GitEntryPayload where
  toJSON = genericToJSON arpOptions
