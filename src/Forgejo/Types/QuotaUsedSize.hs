{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaUsedSize
  ( QuotaUsedSize (..)
  , QuotaUsedSizePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.QuotaUsedSizeAssets (QuotaUsedSizeAssets)
import Forgejo.Types.QuotaUsedSizeGit (QuotaUsedSizeGit)
import Forgejo.Types.QuotaUsedSizeRepos (QuotaUsedSizeRepos)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaUsedSize = QuotaUsedSize
  { assets :: QuotaUsedSizeAssets
  , git :: QuotaUsedSizeGit
  , repos :: QuotaUsedSizeRepos
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaUsedSize where
  parseJSON = withObject "QuotaUsedSize" $ \o ->
    QuotaUsedSize
      <$> o .: "assets"
      <*> o .: "git"
      <*> o .: "repos"

instance ToJSON QuotaUsedSize where
  toJSON = genericToJSON runOptions

data QuotaUsedSizePayload = QuotaUsedSizePayload
  { arpAction :: Text
  , arpRun :: QuotaUsedSize
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaUsedSizePayload where
  parseJSON = withObject "QuotaUsedSizePayload" $ \o ->
    QuotaUsedSizePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaUsedSizePayload where
  toJSON = genericToJSON arpOptions
