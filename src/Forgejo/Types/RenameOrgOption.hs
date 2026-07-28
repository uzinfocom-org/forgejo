{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.RenameOrgOption
  ( RenameOrgOption (..)
  , RenameOrgOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data RenameOrgOption = RenameOrgOption
  { newName :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON RenameOrgOption where
  parseJSON = withObject "RenameOrgOption" $ \o ->
    RenameOrgOption
      <$> o .: "new_name"

instance ToJSON RenameOrgOption where
  toJSON = genericToJSON runOptions

data RenameOrgOptionPayload = RenameOrgOptionPayload
  { arpAction :: Text
  , arpRun :: RenameOrgOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RenameOrgOptionPayload where
  parseJSON = withObject "RenameOrgOptionPayload" $ \o ->
    RenameOrgOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON RenameOrgOptionPayload where
  toJSON = genericToJSON arpOptions
