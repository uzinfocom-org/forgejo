{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PackageFile
  ( PackageFile (..)
  , PackageFilePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PackageFile = PackageFile
  { size :: Int
  , id :: Int
  , md5 :: Text
  , name :: Text
  , sha1 :: Text
  , sha256 :: Text
  , sha512 :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PackageFile where
  parseJSON = withObject "PackageFile" $ \o ->
    PackageFile
      <$> o .: "Size"
      <*> o .: "id"
      <*> o .: "md5"
      <*> o .: "name"
      <*> o .: "sha1"
      <*> o .: "sha256"
      <*> o .: "sha512"

instance ToJSON PackageFile where
  toJSON = genericToJSON runOptions

data PackageFilePayload = PackageFilePayload
  { arpAction :: Text
  , arpRun :: PackageFile
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PackageFilePayload where
  parseJSON = withObject "PackageFilePayload" $ \o ->
    PackageFilePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PackageFilePayload where
  toJSON = genericToJSON arpOptions
