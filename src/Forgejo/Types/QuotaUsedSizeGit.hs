{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaUsedSizeGit
  ( QuotaUsedSizeGit (..)
  , QuotaUsedSizeGitPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaUsedSizeGit = QuotaUsedSizeGit
  { lfs :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaUsedSizeGit where
  parseJSON = withObject "QuotaUsedSizeGit" $ \o ->
    QuotaUsedSizeGit
      <$> o .: "LFS"

instance ToJSON QuotaUsedSizeGit where
  toJSON = genericToJSON runOptions

data QuotaUsedSizeGitPayload = QuotaUsedSizeGitPayload
  { arpAction :: Text
  , arpRun :: QuotaUsedSizeGit
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaUsedSizeGitPayload where
  parseJSON = withObject "QuotaUsedSizeGitPayload" $ \o ->
    QuotaUsedSizeGitPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaUsedSizeGitPayload where
  toJSON = genericToJSON arpOptions
