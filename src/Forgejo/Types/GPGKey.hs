{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GPGKey
  ( GPGKey (..)
  , GPGKeyPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.GPGKeyEmail (GPGKeyEmail)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GPGKey = GPGKey
  { canCertify :: Bool
  , canEncryptComms :: Bool
  , canEncryptStorage :: Bool
  , canSign :: Bool
  , createdAt :: UTCTime
  , emails :: [GPGKeyEmail]
  , expiresAt :: UTCTime
  , id :: Int
  , keyId :: Text
  , primaryKeyid :: Text
  , publicKey :: Text
  , subkeys :: [GPGKey]
  , verified :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GPGKey where
  parseJSON = withObject "GPGKey" $ \o ->
    GPGKey
      <$> o .: "can_certify"
      <*> o .: "can_encrypt_comms"
      <*> o .: "can_encrypt_storage"
      <*> o .: "can_sign"
      <*> o .: "created_at"
      <*> o .: "emails"
      <*> o .: "expires_at"
      <*> o .: "id"
      <*> o .: "key_id"
      <*> o .: "primary_key_id"
      <*> o .: "public_key"
      <*> o .: "subkeys"
      <*> o .: "verified"

instance ToJSON GPGKey where
  toJSON = genericToJSON runOptions

data GPGKeyPayload = GPGKeyPayload
  { arpAction :: Text
  , arpRun :: GPGKey
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GPGKeyPayload where
  parseJSON = withObject "GPGKeyPayload" $ \o ->
    GPGKeyPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GPGKeyPayload where
  toJSON = genericToJSON arpOptions
