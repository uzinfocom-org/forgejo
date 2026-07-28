{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Attachment
  ( Attachment (..)
  , AttachmentPayload (..)
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

data AttachmentType = Internal | External
  deriving (Eq, FromJSON, Generic, Show, ToJSON)

data Attachment = Attachment
  { browserDownloadUrl :: Text
  , createdAt :: UTCTime
  , downloadCount :: Int
  , id :: Int
  , name :: Text
  , size :: Int
  , aType :: AttachmentType
  , uuid :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Attachment where
  parseJSON = withObject "Attachment" $ \o ->
    Attachment
      <$> o .: "browser_download_url"
      <*> o .: "created_at"
      <*> o .: "download_count"
      <*> o .: "id"
      <*> o .: "name"
      <*> o .: "size"
      <*> o .: "type"
      <*> o .: "uuid"

instance ToJSON Attachment where
  toJSON = genericToJSON runOptions

data AttachmentPayload = AttachmentPayload
  { arpAction :: Text
  , arpRun :: Attachment
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON AttachmentPayload where
  parseJSON = withObject "AttachmentPayload" $ \o ->
    AttachmentPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON AttachmentPayload where
  toJSON = genericToJSON arpOptions
