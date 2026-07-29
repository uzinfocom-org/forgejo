{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateStatusOption
  ( CreateStatusOption (..)
  , CreateStatusOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.CommitStatus (CommitStatusState)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateStatusOption = CreateStatusOption
  { context :: Text
  , description :: Text
  , state :: CommitStatusState
  , targetUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateStatusOption where
  parseJSON = withObject "CreateStatusOption" $ \o ->
    CreateStatusOption
      <$> o .: "context"
      <*> o .: "description"
      <*> o .: "state"
      <*> o .: "target_url"

instance ToJSON CreateStatusOption where
  toJSON = genericToJSON runOptions

data CreateStatusOptionPayload = CreateStatusOptionPayload
  { arpAction :: Text
  , arpRun :: CreateStatusOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateStatusOptionPayload where
  parseJSON = withObject "CreateStatusOptionPayload" $ \o ->
    CreateStatusOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateStatusOptionPayload where
  toJSON = genericToJSON arpOptions
