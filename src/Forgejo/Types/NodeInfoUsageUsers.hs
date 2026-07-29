{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.NodeInfoUsageUsers
  ( NodeInfoUsageUsers (..)
  , NodeInfoUsageUsersPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data NodeInfoUsageUsers = NodeInfoUsageUsers
  { activeHalfyear :: Int
  , activeMonth :: Int
  , total :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON NodeInfoUsageUsers where
  parseJSON = withObject "NodeInfoUsageUsers" $ \o ->
    NodeInfoUsageUsers
      <$> o .: "activeHalfyear"
      <*> o .: "activeMonth"
      <*> o .: "total"

instance ToJSON NodeInfoUsageUsers where
  toJSON = genericToJSON runOptions

data NodeInfoUsageUsersPayload = NodeInfoUsageUsersPayload
  { arpAction :: Text
  , arpRun :: NodeInfoUsageUsers
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NodeInfoUsageUsersPayload where
  parseJSON = withObject "NodeInfoUsageUsersPayload" $ \o ->
    NodeInfoUsageUsersPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NodeInfoUsageUsersPayload where
  toJSON = genericToJSON arpOptions
