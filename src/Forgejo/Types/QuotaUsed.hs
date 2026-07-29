{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaUsed
  ( QuotaUsed (..)
  , QuotaUsedPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.QuotaUsedSize (QuotaUsedSize)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaUsed = QuotaUsed
  { size :: QuotaUsedSize
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaUsed where
  parseJSON = withObject "QuotaUsed" $ \o ->
    QuotaUsed
      <$> o .: "size"

instance ToJSON QuotaUsed where
  toJSON = genericToJSON runOptions

data QuotaUsedPayload = QuotaUsedPayload
  { arpAction :: Text
  , arpRun :: QuotaUsed
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaUsedPayload where
  parseJSON = withObject "QuotaUsedPayload" $ \o ->
    QuotaUsedPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaUsedPayload where
  toJSON = genericToJSON arpOptions
