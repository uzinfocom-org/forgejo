{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaUsedSizeAssetsPackages
  ( QuotaUsedSizeAssetsPackages (..)
  , QuotaUsedSizeAssetsPackagesPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaUsedSizeAssetsPackages = QuotaUsedSizeAssetsPackages
  { all :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaUsedSizeAssetsPackages where
  parseJSON = withObject "QuotaUsedSizeAssetsPackages" $ \o ->
    QuotaUsedSizeAssetsPackages
      <$> o .: "all"

instance ToJSON QuotaUsedSizeAssetsPackages where
  toJSON = genericToJSON runOptions

data QuotaUsedSizeAssetsPackagesPayload = QuotaUsedSizeAssetsPackagesPayload
  { arpAction :: Text
  , arpRun :: QuotaUsedSizeAssetsPackages
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaUsedSizeAssetsPackagesPayload where
  parseJSON = withObject "QuotaUsedSizeAssetsPackagesPayload" $ \o ->
    QuotaUsedSizeAssetsPackagesPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaUsedSizeAssetsPackagesPayload where
  toJSON = genericToJSON arpOptions
