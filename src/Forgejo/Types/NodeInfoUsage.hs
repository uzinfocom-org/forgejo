{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.NodeInfoUsage
  ( NodeInfoUsage (..)
  , NodeInfoUsagePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.NodeInfoUsageUsers (NodeInfoUsageUsers)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data NodeInfoUsage = NodeInfoUsage
  { localComments :: Int
  , localPosts :: Int
  , users :: NodeInfoUsageUsers
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON NodeInfoUsage where
  parseJSON = withObject "NodeInfoUsage" $ \o ->
    NodeInfoUsage
      <$> o .: "localComments"
      <*> o .: "localPosts"
      <*> o .: "users"

instance ToJSON NodeInfoUsage where
  toJSON = genericToJSON runOptions

data NodeInfoUsagePayload = NodeInfoUsagePayload
  { arpAction :: Text
  , arpRun :: NodeInfoUsage
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NodeInfoUsagePayload where
  parseJSON = withObject "NodeInfoUsagePayload" $ \o ->
    NodeInfoUsagePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NodeInfoUsagePayload where
  toJSON = genericToJSON arpOptions
