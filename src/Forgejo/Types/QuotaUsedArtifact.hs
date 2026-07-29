{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaUsedArtifact
  ( QuotaUsedArtifact (..)
  , QuotaUsedArtifactPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaUsedArtifact = QuotaUsedArtifact
  { htmlUrl :: Text
  , name :: Text
  , size :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaUsedArtifact where
  parseJSON = withObject "QuotaUsedArtifact" $ \o ->
    QuotaUsedArtifact
      <$> o .: "html_url"
      <*> o .: "name"
      <*> o .: "size"

instance ToJSON QuotaUsedArtifact where
  toJSON = genericToJSON runOptions

data QuotaUsedArtifactPayload = QuotaUsedArtifactPayload
  { arpAction :: Text
  , arpRun :: QuotaUsedArtifact
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaUsedArtifactPayload where
  parseJSON = withObject "QuotaUsedArtifactPayload" $ \o ->
    QuotaUsedArtifactPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaUsedArtifactPayload where
  toJSON = genericToJSON arpOptions
