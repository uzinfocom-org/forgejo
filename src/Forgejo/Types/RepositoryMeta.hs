{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RepositoryMeta
  ( RepositoryMeta (..)
  , RepositoryMetaPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RepositoryMeta = RepositoryMeta
  { fullName :: Text
  , id :: Int
  , name :: Text
  , owner :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RepositoryMeta where
  parseJSON = withObject "RepositoryMeta" $ \o ->
    RepositoryMeta
      <$> o .: "full_name"
      <*> o .: "id"
      <*> o .: "name"
      <*> o .: "owner"

instance ToJSON RepositoryMeta where
  toJSON = genericToJSON runOptions

data RepositoryMetaPayload = RepositoryMetaPayload
  { arpAction :: Text
  , arpRun :: RepositoryMeta
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RepositoryMetaPayload where
  parseJSON = withObject "RepositoryMetaPayload" $ \o ->
    RepositoryMetaPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RepositoryMetaPayload where
  toJSON = genericToJSON arpOptions
