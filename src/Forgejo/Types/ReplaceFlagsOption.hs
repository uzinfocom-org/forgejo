{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ReplaceFlagsOption
  ( ReplaceFlagsOption (..)
  , ReplaceFlagsOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data ReplaceFlagsOption = ReplaceFlagsOption
  { flags :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ReplaceFlagsOption where
  parseJSON = withObject "ReplaceFlagsOption" $ \o ->
    ReplaceFlagsOption
      <$> o .: "flags"

instance ToJSON ReplaceFlagsOption where
  toJSON = genericToJSON runOptions

data ReplaceFlagsOptionPayload = ReplaceFlagsOptionPayload
  { arpAction :: Text
  , arpRun :: ReplaceFlagsOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ReplaceFlagsOptionPayload where
  parseJSON = withObject "ReplaceFlagsOptionPayload" $ \o ->
    ReplaceFlagsOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ReplaceFlagsOptionPayload where
  toJSON = genericToJSON arpOptions
