{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ActionRunner
  ( ActionRunner (..)
  , ActionRunnerPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arrpOptions :: Options
arrpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}

arrOptions :: Options
arrOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Status = Offline | Idle | Active
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data ActionRunner = ActionRunner
  { arrDescription :: Text
  , arrEphemeral :: Bool
  , arrId :: Int
  , arrLabels :: [Text]
  , arrName :: Text
  , arrOwnerId :: Int
  , arrRepoId :: Int
  , arrStatus :: Status
  , arrUuid :: Text
  , arrVersion :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ActionRunner where
  parseJSON = withObject "ActionRunner" $ \o ->
    ActionRunner
      <$> o .: "description"
      <*> o .: "ephemeral"
      <*> o .: "id"
      <*> o .: "labels"
      <*> o .: "name"
      <*> o .: "owner_id"
      <*> o .: "repo_id"
      <*> o .: "status"
      <*> o .: "uuid"
      <*> o .: "version"

instance ToJSON ActionRunner where
  toJSON = genericToJSON arrOptions

data ActionRunnerPayload = ActionRunnerPayload
  { arpAction :: Text
  , arpRun :: ActionRunner
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ActionRunnerPayload where
  parseJSON = withObject "ActionRunnerPayload" $ \o ->
    ActionRunnerPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ActionRunnerPayload where
  toJSON = genericToJSON arrpOptions
