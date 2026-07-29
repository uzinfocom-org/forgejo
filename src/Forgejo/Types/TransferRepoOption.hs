{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.TransferRepoOption
  ( TransferRepoOption (..)
  , TransferRepoOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data TransferRepoOption = TransferRepoOption
  { newOwner :: Text
  , teamIds :: [Int]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON TransferRepoOption where
  parseJSON = withObject "TransferRepoOption" $ \o ->
    TransferRepoOption
      <$> o .: "new_owner"
      <*> o .: "team_ids"

instance ToJSON TransferRepoOption where
  toJSON = genericToJSON runOptions

data TransferRepoOptionPayload = TransferRepoOptionPayload
  { arpAction :: Text
  , arpRun :: TransferRepoOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON TransferRepoOptionPayload where
  parseJSON = withObject "TransferRepoOptionPayload" $ \o ->
    TransferRepoOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON TransferRepoOptionPayload where
  toJSON = genericToJSON arpOptions
