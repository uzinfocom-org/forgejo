{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ActionVariable
  ( ActionVariable (..)
  , ActionVariablePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

avpOptions :: Options
avpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

avOptions :: Options
avOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

data ActionVariable = ActionVariable
  { avDate :: Text
  , avName :: Text
  , avOwnerId :: Int
  , avRepoId :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ActionVariable where
  parseJSON = withObject "ActionVariable" $ \o ->
    ActionVariable
      <$> o .: "data"
      <*> o .: "name"
      <*> o .: "owner_id"
      <*> o .: "repo_id"

instance ToJSON ActionVariable where
  toJSON = genericToJSON avOptions

data ActionVariablePayload = ActionVariablePayload
  { arpAction :: Text
  , arpRun :: ActionVariable
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ActionVariablePayload where
  parseJSON = withObject "ActionVariablePayload" $ \o ->
    ActionVariablePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ActionVariablePayload where
  toJSON = genericToJSON avpOptions
