{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GeneralAPISettings
  ( GeneralAPISettings (..)
  , GeneralAPISettingsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GeneralAPISettings = GeneralAPISettings
  { defaultGitTreesPerPage :: Int
  , defaultMaxBlobSize :: Int
  , defaultPagingNum :: Int
  , maxResponseItems :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GeneralAPISettings where
  parseJSON = withObject "GeneralAPISettings" $ \o ->
    GeneralAPISettings
      <$> o .: "default_git_trees_per_page"
      <*> o .: "default_max_blob_size"
      <*> o .: "default_paging_num"
      <*> o .: "max_response_items"

instance ToJSON GeneralAPISettings where
  toJSON = genericToJSON runOptions

data GeneralAPISettingsPayload = GeneralAPISettingsPayload
  { arpAction :: Text
  , arpRun :: GeneralAPISettings
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GeneralAPISettingsPayload where
  parseJSON = withObject "GeneralAPISettingsPayload" $ \o ->
    GeneralAPISettingsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GeneralAPISettingsPayload where
  toJSON = genericToJSON arpOptions
