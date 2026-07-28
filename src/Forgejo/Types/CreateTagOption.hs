{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateTagOption
  ( CreateTagOption (..)
  , CreateTagOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateTagOption = CreateTagOption
  { message :: Text
  , tagName :: Text
  , target :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateTagOption where
  parseJSON = withObject "CreateTagOption" $ \o ->
    CreateTagOption
      <$> o .: "message"
      <*> o .: "tag_name"
      <*> o .: "target"

instance ToJSON CreateTagOption where
  toJSON = genericToJSON runOptions

data CreateTagOptionPayload = CreateTagOptionPayload
  { arpAction :: Text
  , arpRun :: CreateTagOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateTagOptionPayload where
  parseJSON = withObject "CreateTagOptionPayload" $ \o ->
    CreateTagOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateTagOptionPayload where
  toJSON = genericToJSON arpOptions
