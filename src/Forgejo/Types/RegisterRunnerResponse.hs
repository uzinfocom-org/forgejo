{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RegisterRunnerResponse
  ( RegisterRunnerResponse (..)
  , RegisterRunnerResponsePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RegisterRunnerResponse = RegisterRunnerResponse
  { id :: Int
  , token :: Text
  , uuid :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RegisterRunnerResponse where
  parseJSON = withObject "RegisterRunnerResponse" $ \o ->
    RegisterRunnerResponse
      <$> o .: "id"
      <*> o .: "token"
      <*> o .: "uuid"

instance ToJSON RegisterRunnerResponse where
  toJSON = genericToJSON runOptions

data RegisterRunnerResponsePayload = RegisterRunnerResponsePayload
  { arpAction :: Text
  , arpRun :: RegisterRunnerResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RegisterRunnerResponsePayload where
  parseJSON = withObject "RegisterRunnerResponsePayload" $ \o ->
    RegisterRunnerResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RegisterRunnerResponsePayload where
  toJSON = genericToJSON arpOptions
