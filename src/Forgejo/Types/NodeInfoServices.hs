{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.NodeInfoServices
  ( NodeInfoServices (..)
  , NodeInfoServicesPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data NodeInfoServices = NodeInfoServices
  { inbound :: [Text]
  , outbound :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON NodeInfoServices where
  parseJSON = withObject "NodeInfoServices" $ \o ->
    NodeInfoServices
      <$> o .: "inbound"
      <*> o .: "outbound"

instance ToJSON NodeInfoServices where
  toJSON = genericToJSON runOptions

data NodeInfoServicesPayload = NodeInfoServicesPayload
  { arpAction :: Text
  , arpRun :: NodeInfoServices
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NodeInfoServicesPayload where
  parseJSON = withObject "NodeInfoServicesPayload" $ \o ->
    NodeInfoServicesPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NodeInfoServicesPayload where
  toJSON = genericToJSON arpOptions
