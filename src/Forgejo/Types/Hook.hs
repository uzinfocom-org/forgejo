{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Hook
  ( Hook (..)
  , HookPayload (..)
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

data Hook = Hook
  { active :: Bool
  , authorizationHeader :: Text
  , branchFilter :: Text
  , contentType :: Text
  , createdAt :: UTCTime
  , events :: [Text]
  , id :: Int
  , metadata :: Text
  , hType :: Text
  , updatedAt :: UTCTime
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Hook where
  parseJSON = withObject "Hook" $ \o ->
    Hook
      <$> o .: "active"
      <*> o .: "authorization_header"
      <*> o .: "branch_filter"
      <*> o .: "content_type"
      <*> o .: "created_at"
      <*> o .: "events"
      <*> o .: "id"
      <*> o .: "metadata"
      <*> o .: "type"
      <*> o .: "updated_at"
      <*> o .: "url"

instance ToJSON Hook where
  toJSON = genericToJSON runOptions

data HookPayload = HookPayload
  { arpAction :: Text
  , arpRun :: Hook
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON HookPayload where
  parseJSON = withObject "HookPayload" $ \o ->
    HookPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON HookPayload where
  toJSON = genericToJSON arpOptions
