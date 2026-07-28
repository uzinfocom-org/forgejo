{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.UpdateUserAvatarOption
  ( UpdateUserAvatarOption (..)
  , UpdateUserAvatarOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data UpdateUserAvatarOption = UpdateUserAvatarOption
  { image :: Text -- image must be base64 encoded
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON UpdateUserAvatarOption where
  parseJSON = withObject "UpdateUserAvatarOption" $ \o ->
    UpdateUserAvatarOption
      <$> o .: "image"

instance ToJSON UpdateUserAvatarOption where
  toJSON = genericToJSON runOptions

data UpdateUserAvatarOptionPayload = UpdateUserAvatarOptionPayload
  { arpAction :: Text
  , arpRun :: UpdateUserAvatarOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON UpdateUserAvatarOptionPayload where
  parseJSON = withObject "UpdateUserAvatarOptionPayload" $ \o ->
    UpdateUserAvatarOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON UpdateUserAvatarOptionPayload where
  toJSON = genericToJSON arpOptions
