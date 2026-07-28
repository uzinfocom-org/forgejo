{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Compare
  ( Compare (..)
  , ComparePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.Commit (Commit)
import Forgejo.Types.CommitAffectedFiles (CommitAffectedFiles)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Compare = Compare
  { commits :: [Commit]
  , files :: [CommitAffectedFiles]
  , totalCommits :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Compare where
  parseJSON = withObject "Compare" $ \o ->
    Compare
      <$> o .: "commits"
      <*> o .: "files"
      <*> o .: "total_commits"

instance ToJSON Compare where
  toJSON = genericToJSON runOptions

data ComparePayload = ComparePayload
  { arpAction :: Text
  , arpRun :: Compare
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ComparePayload where
  parseJSON = withObject "ComparePayload" $ \o ->
    ComparePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ComparePayload where
  toJSON = genericToJSON arpOptions
