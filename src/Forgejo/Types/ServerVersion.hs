{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ServerVersion
  ( ServerVersion (..)
  , ServerVersionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data ServerVersion = ServerVersion
  { version :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ServerVersion where
  parseJSON = withObject "ServerVersion" $ \o ->
    ServerVersion
      <$> o .: "version"

instance ToJSON ServerVersion where
  toJSON = genericToJSON runOptions

data ServerVersionPayload = ServerVersionPayload
  { arpAction :: Text
  , arpRun :: ServerVersion
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ServerVersionPayload where
  parseJSON = withObject "ServerVersionPayload" $ \o ->
    ServerVersionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ServerVersionPayload where
  toJSON = genericToJSON arpOptions
