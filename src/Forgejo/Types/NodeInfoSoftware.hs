{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.NodeInfoSoftware
  ( NodeInfoSoftware (..)
  , NodeInfoSoftwarePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data NodeInfoSoftware = NodeInfoSoftware
  { homepage :: Text
  , name :: Text
  , repository :: Text
  , version :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON NodeInfoSoftware where
  parseJSON = withObject "NodeInfoSoftware" $ \o ->
    NodeInfoSoftware
      <$> o .: "homepage"
      <*> o .: "name"
      <*> o .: "repository"
      <*> o .: "version"

instance ToJSON NodeInfoSoftware where
  toJSON = genericToJSON runOptions

data NodeInfoSoftwarePayload = NodeInfoSoftwarePayload
  { arpAction :: Text
  , arpRun :: NodeInfoSoftware
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NodeInfoSoftwarePayload where
  parseJSON = withObject "NodeInfoSoftwarePayload" $ \o ->
    NodeInfoSoftwarePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NodeInfoSoftwarePayload where
  toJSON = genericToJSON arpOptions
