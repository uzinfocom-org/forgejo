{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.UpdateRepoAvatarOption
  ( UpdateRepoAvatarOption (..)
  , UpdateRepoAvatarOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data UpdateRepoAvatarOption = UpdateRepoAvatarOption
  { image :: Text -- image must be base64 encoded
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON UpdateRepoAvatarOption where
  parseJSON = withObject "UpdateRepoAvatarOption" $ \o ->
    UpdateRepoAvatarOption
      <$> o .: "image"

instance ToJSON UpdateRepoAvatarOption where
  toJSON = genericToJSON runOptions

data UpdateRepoAvatarOptionPayload = UpdateRepoAvatarOptionPayload
  { arpAction :: Text
  , arpRun :: UpdateRepoAvatarOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON UpdateRepoAvatarOptionPayload where
  parseJSON = withObject "UpdateRepoAvatarOptionPayload" $ \o ->
    UpdateRepoAvatarOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON UpdateRepoAvatarOptionPayload where
  toJSON = genericToJSON arpOptions
