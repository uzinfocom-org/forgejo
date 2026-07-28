{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditReactionOption
  ( EditReactionOption (..)
  , EditReactionOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditReactionOption = EditReactionOption
  { content :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditReactionOption where
  parseJSON = withObject "EditReactionOption" $ \o ->
    EditReactionOption
      <$> o .: "content"

instance ToJSON EditReactionOption where
  toJSON = genericToJSON runOptions

data EditReactionOptionPayload = EditReactionOptionPayload
  { arpAction :: Text
  , arpRun :: EditReactionOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditReactionOptionPayload where
  parseJSON = withObject "EditReactionOptionPayload" $ \o ->
    EditReactionOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditReactionOptionPayload where
  toJSON = genericToJSON arpOptions
