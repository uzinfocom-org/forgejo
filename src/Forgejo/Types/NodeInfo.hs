{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.NodeInfo
  ( NodeInfo (..)
  , NodeInfoPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.NodeInfoServices (NodeInfoServices)
import Forgejo.Types.NodeInfoSoftware (NodeInfoSoftware)
import Forgejo.Types.NodeInfoUsage (NodeInfoUsage)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data NodeInfo = NodeInfo
  { metadata :: Text -- FIXME: original - {}
  , openRegistrations :: Bool
  , protocols :: [Text]
  , services :: NodeInfoServices
  , software :: NodeInfoSoftware
  , usage :: NodeInfoUsage
  , version :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON NodeInfo where
  parseJSON = withObject "NodeInfo" $ \o ->
    NodeInfo
      <$> o .: "metadata"
      <*> o .: "openRegistrations"
      <*> o .: "protocols"
      <*> o .: "services"
      <*> o .: "software"
      <*> o .: "usage"
      <*> o .: "version"

instance ToJSON NodeInfo where
  toJSON = genericToJSON runOptions

data NodeInfoPayload = NodeInfoPayload
  { arpAction :: Text
  , arpRun :: NodeInfo
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NodeInfoPayload where
  parseJSON = withObject "NodeInfoPayload" $ \o ->
    NodeInfoPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NodeInfoPayload where
  toJSON = genericToJSON arpOptions
