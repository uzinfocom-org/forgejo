{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Reference
  ( Reference (..)
  , ReferencePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.GitObject (GitObject)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Reference = Reference
  { object :: GitObject
  , ref :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Reference where
  parseJSON = withObject "Reference" $ \o ->
    Reference
      <$> o .: "object"
      <*> o .: "ref"
      <*> o .: "url"

instance ToJSON Reference where
  toJSON = genericToJSON runOptions

data ReferencePayload = ReferencePayload
  { arpAction :: Text
  , arpRun :: Reference
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ReferencePayload where
  parseJSON = withObject "ReferencePayload" $ \o ->
    ReferencePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ReferencePayload where
  toJSON = genericToJSON arpOptions
