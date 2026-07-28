{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Package
  ( Package (..)
  , PackagePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Repository (Repository)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Package = Package
  { createdAt :: UTCTime
  , creator :: User
  , htmlUrl :: Text
  , id :: Int
  , name :: Text
  , owner :: User
  , repository :: Repository
  , pType :: Text
  , version :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Package where
  parseJSON = withObject "Package" $ \o ->
    Package
      <$> o .: "created_at"
      <*> o .: "creator"
      <*> o .: "htmlUrl"
      <*> o .: "id"
      <*> o .: "name"
      <*> o .: "owner"
      <*> o .: "repository"
      <*> o .: "type"
      <*> o .: "version"

instance ToJSON Package where
  toJSON = genericToJSON runOptions

data PackagePayload = PackagePayload
  { arpAction :: Text
  , arpRun :: Package
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PackagePayload where
  parseJSON = withObject "PackagePayload" $ \o ->
    PackagePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PackagePayload where
  toJSON = genericToJSON arpOptions
