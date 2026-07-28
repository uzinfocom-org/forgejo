{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaUsedPackage
  ( QuotaUsedPackage (..)
  , QuotaUsedPackagePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data QuotaUsedPackage = QuotaUsedPackage
  { htmlUrl :: Text
  , name :: Text
  , size :: Int
  , qupType :: Text
  , version :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON QuotaUsedPackage where
  parseJSON = withObject "QuotaUsedPackage" $ \o ->
    QuotaUsedPackage
      <$> o .: "html_url"
      <*> o .: "name"
      <*> o .: "size"
      <*> o .: "type"
      <*> o .: "version"

instance ToJSON QuotaUsedPackage where
  toJSON = genericToJSON runOptions

data QuotaUsedPackagePayload = QuotaUsedPackagePayload
  { arpAction :: Text
  , arpRun :: QuotaUsedPackage
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaUsedPackagePayload where
  parseJSON = withObject "QuotaUsedPackagePayload" $ \o ->
    QuotaUsedPackagePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaUsedPackagePayload where
  toJSON = genericToJSON arpOptions
