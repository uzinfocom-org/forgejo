{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RenameUserOption
  ( RenameUserOption (..)
  , RenameUserOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RenameUserOption = RenameUserOption
  { newUsername :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RenameUserOption where
  parseJSON = withObject "RenameUserOption" $ \o ->
    RenameUserOption
      <$> o .: "new_username"

instance ToJSON RenameUserOption where
  toJSON = genericToJSON runOptions

data RenameUserOptionPayload = RenameUserOptionPayload
  { arpAction :: Text
  , arpRun :: RenameUserOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RenameUserOptionPayload where
  parseJSON = withObject "RenameUserOptionPayload" $ \o ->
    RenameUserOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RenameUserOptionPayload where
  toJSON = genericToJSON arpOptions
