{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaUsedSizeRepos
  ( QuotaUsedSizeRepos (..)
  , QuotaUsedSizeReposPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaUsedSizeRepos = QuotaUsedSizeRepos
  { private :: Int
  , public :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaUsedSizeRepos where
  parseJSON = withObject "QuotaUsedSizeRepos" $ \o ->
    QuotaUsedSizeRepos
      <$> o .: "private"
      <*> o .: "public"

instance ToJSON QuotaUsedSizeRepos where
  toJSON = genericToJSON runOptions

data QuotaUsedSizeReposPayload = QuotaUsedSizeReposPayload
  { arpAction :: Text
  , arpRun :: QuotaUsedSizeRepos
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaUsedSizeReposPayload where
  parseJSON = withObject "QuotaUsedSizeReposPayload" $ \o ->
    QuotaUsedSizeReposPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaUsedSizeReposPayload where
  toJSON = genericToJSON arpOptions
