{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PayloadCommitVerification
  ( PayloadCommitVerification (..)
  , PayloadCommitVerificationPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.PayloadUser (PayloadUser)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data PayloadCommitVerification = PayloadCommitVerification
  { payload :: Text
  , reason :: Text
  , signature :: Text
  , signer :: PayloadUser
  , verified :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON PayloadCommitVerification where
  parseJSON = withObject "PayloadCommitVerification" $ \o ->
    PayloadCommitVerification
      <$> o .: "payload"
      <*> o .: "reason"
      <*> o .: "signature"
      <*> o .: "signer"
      <*> o .: "verified"

instance ToJSON PayloadCommitVerification where
  toJSON = genericToJSON runOptions

data PayloadCommitVerificationPayload = PayloadCommitVerificationPayload
  { arpAction :: Text
  , arpRun :: PayloadCommitVerification
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PayloadCommitVerificationPayload where
  parseJSON = withObject "PayloadCommitVerificationPayload" $ \o ->
    PayloadCommitVerificationPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON PayloadCommitVerificationPayload where
  toJSON = genericToJSON arpOptions
