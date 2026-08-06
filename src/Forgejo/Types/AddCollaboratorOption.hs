{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.AddCollaboratorOption
  ( AddCollaboratorOption (..)
  , AddCollaboratorOptionPayload (..)
  , Permission
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

acopOptions :: Options
acopOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}

acoOptions :: Options
acoOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Permission = READ | WRITE | ADMIN
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data AddCollaboratorOption = AddCollaboratorOption
  { acoPermission :: Permission
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON AddCollaboratorOption where
  parseJSON = withObject "AddCollaboratorOption" $ \o ->
    AddCollaboratorOption
      <$> o .: "permission"

instance ToJSON AddCollaboratorOption where
  toJSON = genericToJSON acoOptions

data AddCollaboratorOptionPayload = AddCollaboratorOptionPayload
  { arpAction :: Text
  , arpRun :: AddCollaboratorOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON AddCollaboratorOptionPayload where
  parseJSON = withObject "AddCollaboratorOptionPayload" $ \o ->
    AddCollaboratorOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON AddCollaboratorOptionPayload where
  toJSON = genericToJSON acopOptions
