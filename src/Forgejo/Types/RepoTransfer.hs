{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RepoTransfer
  ( RepoTransfer (..)
  , RepoTransferPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.Team (Team)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RepoTransfer = RepoTransfer
  { doer :: User
  , recipient :: User
  , teams :: [Team]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RepoTransfer where
  parseJSON = withObject "RepoTransfer" $ \o ->
    RepoTransfer
      <$> o .: "doer"
      <*> o .: "recipient"
      <*> o .: "teams"

instance ToJSON RepoTransfer where
  toJSON = genericToJSON runOptions

data RepoTransferPayload = RepoTransferPayload
  { arpAction :: Text
  , arpRun :: RepoTransfer
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RepoTransferPayload where
  parseJSON = withObject "RepoTransferPayload" $ \o ->
    RepoTransferPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RepoTransferPayload where
  toJSON = genericToJSON arpOptions
