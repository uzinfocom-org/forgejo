{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Email
  ( Email (..)
  , EmailPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Email = Email
  { email :: Text
  , primary :: Bool
  , userId :: Int
  , username :: Text
  , verified :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Email where
  parseJSON = withObject "Email" $ \o ->
    Email
      <$> o .: "email"
      <*> o .: "primary"
      <*> o .: "user_id"
      <*> o .: "username"
      <*> o .: "verified"

instance ToJSON Email where
  toJSON = genericToJSON runOptions

data EmailPayload = EmailPayload
  { arpAction :: Text
  , arpRun :: Email
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EmailPayload where
  parseJSON = withObject "EmailPayload" $ \o ->
    EmailPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EmailPayload where
  toJSON = genericToJSON arpOptions
