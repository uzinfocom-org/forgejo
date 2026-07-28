{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateForkOption
  ( CreateForkOption (..)
  , CreateForkOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateForkOption = CreateForkOption
  { name :: Text
  , organization :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateForkOption where
  parseJSON = withObject "CreateForkOption" $ \o ->
    CreateForkOption
      <$> o .: "name"
      <*> o .: "organization"

instance ToJSON CreateForkOption where
  toJSON = genericToJSON runOptions

data CreateForkOptionPayload = CreateForkOptionPayload
  { arpAction :: Text
  , arpRun :: CreateForkOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateForkOptionPayload where
  parseJSON = withObject "CreateForkOptionPayload" $ \o ->
    CreateForkOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateForkOptionPayload where
  toJSON = genericToJSON arpOptions
