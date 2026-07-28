{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GitObject
  ( GitObject (..)
  , GitObjectPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GitObject = GitObject
  { sha :: Text
  , goType :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GitObject where
  parseJSON = withObject "GitObject" $ \o ->
    GitObject
      <$> o .: "sha"
      <*> o .: "type"
      <*> o .: "url"

instance ToJSON GitObject where
  toJSON = genericToJSON runOptions

data GitObjectPayload = GitObjectPayload
  { arpAction :: Text
  , arpRun :: GitObject
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GitObjectPayload where
  parseJSON = withObject "GitObjectPayload" $ \o ->
    GitObjectPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GitObjectPayload where
  toJSON = genericToJSON arpOptions
