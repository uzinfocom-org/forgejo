{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PublicKey
  ( PublicKey (..)
  , PublicKeyPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PublicKey = PublicKey
  { createdAt :: UTCTime
  , fingerprint :: Text
  , id :: Int
  , key :: Text
  , keyType :: Text
  , readOnly :: Text
  , title :: Text
  , url :: Text
  , user :: User
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PublicKey where
  parseJSON = withObject "PublicKey" $ \o ->
    PublicKey
      <$> o .: "created_at"
      <*> o .: "fingerprint"
      <*> o .: "id"
      <*> o .: "key"
      <*> o .: "key_type"
      <*> o .: "read_only"
      <*> o .: "title"
      <*> o .: "url"
      <*> o .: "user"

instance ToJSON PublicKey where
  toJSON = genericToJSON runOptions

data PublicKeyPayload = PublicKeyPayload
  { arpAction :: Text
  , arpRun :: PublicKey
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PublicKeyPayload where
  parseJSON = withObject "PublicKeyPayload" $ \o ->
    PublicKeyPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PublicKeyPayload where
  toJSON = genericToJSON arpOptions
