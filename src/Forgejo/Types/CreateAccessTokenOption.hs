{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateAccessTokenOption
  ( CreateAccessTokenOption (..)
  , CreateAccessTokenOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.RepoTargetOption (RepoTargetOption)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateAccessTokenOption = CreateAccessTokenOption
  { name :: Text
  , repositories :: [RepoTargetOption]
  , scopes :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateAccessTokenOption where
  parseJSON = withObject "CreateAccessTokenOption" $ \o ->
    CreateAccessTokenOption
      <$> o .: "name"
      <*> o .: "repositories"
      <*> o .: "scopes"

instance ToJSON CreateAccessTokenOption where
  toJSON = genericToJSON runOptions

data CreateAccessTokenOptionPayload = CreateAccessTokenOptionPayload
  { arpAction :: Text
  , arpRun :: CreateAccessTokenOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateAccessTokenOptionPayload where
  parseJSON = withObject "CreateAccessTokenOptionPayload" $ \o ->
    CreateAccessTokenOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateAccessTokenOptionPayload where
  toJSON = genericToJSON arpOptions
