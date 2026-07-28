{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaUsedSizeAssetsAttachments
  ( QuotaUsedSizeAssetsAttachments (..)
  , QuotaUsedSizeAssetsAttachmentsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaUsedSizeAssetsAttachments = QuotaUsedSizeAssetsAttachments
  { issues :: Int
  , releases :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaUsedSizeAssetsAttachments where
  parseJSON = withObject "QuotaUsedSizeAssetsAttachments" $ \o ->
    QuotaUsedSizeAssetsAttachments
      <$> o .: "issues"
      <*> o .: "releases"

instance ToJSON QuotaUsedSizeAssetsAttachments where
  toJSON = genericToJSON runOptions

data QuotaUsedSizeAssetsAttachmentsPayload = QuotaUsedSizeAssetsAttachmentsPayload
  { arpAction :: Text
  , arpRun :: QuotaUsedSizeAssetsAttachments
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaUsedSizeAssetsAttachmentsPayload where
  parseJSON = withObject "QuotaUsedSizeAssetsAttachmentsPayload" $ \o ->
    QuotaUsedSizeAssetsAttachmentsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaUsedSizeAssetsAttachmentsPayload where
  toJSON = genericToJSON arpOptions
