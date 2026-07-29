{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaUsedSizeAssets
  ( QuotaUsedSizeAssets (..)
  , QuotaUsedSizeAssetsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.QuotaUsedSizeAssetsAttachments (QuotaUsedSizeAssetsAttachments)
import Forgejo.Types.QuotaUsedSizeAssetsPackages (QuotaUsedSizeAssetsPackages)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaUsedSizeAssets = QuotaUsedSizeAssets
  { artifacts :: Int
  , attachments :: QuotaUsedSizeAssetsAttachments
  , packages :: QuotaUsedSizeAssetsPackages
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaUsedSizeAssets where
  parseJSON = withObject "QuotaUsedSizeAssets" $ \o ->
    QuotaUsedSizeAssets
      <$> o .: "artifacts"
      <*> o .: "attachments"
      <*> o .: "packages"

instance ToJSON QuotaUsedSizeAssets where
  toJSON = genericToJSON runOptions

data QuotaUsedSizeAssetsPayload = QuotaUsedSizeAssetsPayload
  { arpAction :: Text
  , arpRun :: QuotaUsedSizeAssets
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaUsedSizeAssetsPayload where
  parseJSON = withObject "QuotaUsedSizeAssetsPayload" $ \o ->
    QuotaUsedSizeAssetsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaUsedSizeAssetsPayload where
  toJSON = genericToJSON arpOptions
