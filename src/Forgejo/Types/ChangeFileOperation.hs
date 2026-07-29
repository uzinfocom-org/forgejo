{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ChangeFileOperation
  ( ChangeFileOperation (..)
  , ChangeFileOperationPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Operation = Create | Update | Delete
  deriving (Eq, FromJSON, Generic, Show, ToJSON)

data ChangeFileOperation = ChangeFileOperation
  { content :: Text
  , fromPath :: Text
  , operation :: Operation
  , path :: Text
  , sha :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ChangeFileOperation where
  parseJSON = withObject "ChangeFileOperation" $ \o ->
    ChangeFileOperation
      <$> o .: "content"
      <*> o .: "from_path"
      <*> o .: "operation"
      <*> o .: "path"
      <*> o .: "sha"

instance ToJSON ChangeFileOperation where
  toJSON = genericToJSON runOptions

data ChangeFileOperationPayload = ChangeFileOperationPayload
  { arpAction :: Text
  , arpRun :: ChangeFileOperation
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ChangeFileOperationPayload where
  parseJSON = withObject "ChangeFileOperationPayload" $ \o ->
    ChangeFileOperationPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ChangeFileOperationPayload where
  toJSON = genericToJSON arpOptions
