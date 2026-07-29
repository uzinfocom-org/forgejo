{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PayloadUser
  ( PayloadUser (..)
  , PayloadUserPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PayloadUser = PayloadUser
  { email :: Text
  , name :: Text
  , username :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PayloadUser where
  parseJSON = withObject "PayloadUser" $ \o ->
    PayloadUser
      <$> o .: "email"
      <*> o .: "name"
      <*> o .: "username"

instance ToJSON PayloadUser where
  toJSON = genericToJSON runOptions

data PayloadUserPayload = PayloadUserPayload
  { arpAction :: Text
  , arpRun :: PayloadUser
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PayloadUserPayload where
  parseJSON = withObject "PayloadUserPayload" $ \o ->
    PayloadUserPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PayloadUserPayload where
  toJSON = genericToJSON arpOptions
