{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateUserOption
  ( CreateUserOption (..)
  , CreateUserOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateUserOption = CreateUserOption
  { createdAt :: UTCTime
  , email :: Text
  , fullName :: Text
  , loginName :: Text
  , mustChangePassword :: Bool
  , password :: Text
  , restricted :: Bool
  , sendNotify :: Bool
  , sourceId :: Int
  , username :: Text
  , visiblity :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateUserOption where
  parseJSON = withObject "CreateUserOption" $ \o ->
    CreateUserOption
      <$> o .: "created_ad"
      <*> o .: "email"
      <*> o .: "full_name"
      <*> o .: "login_name"
      <*> o .: "must_change_password"
      <*> o .: "password"
      <*> o .: "restricted"
      <*> o .: "send_notify"
      <*> o .: "source_id"
      <*> o .: "username"
      <*> o .: "visibility"

instance ToJSON CreateUserOption where
  toJSON = genericToJSON runOptions

data CreateUserOptionPayload = CreateUserOptionPayload
  { arpAction :: Text
  , arpRun :: CreateUserOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateUserOptionPayload where
  parseJSON = withObject "CreateUserOptionPayload" $ \o ->
    CreateUserOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateUserOptionPayload where
  toJSON = genericToJSON arpOptions
