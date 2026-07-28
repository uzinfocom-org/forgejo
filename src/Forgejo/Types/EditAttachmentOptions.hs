{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditAttachmentOptions
  ( EditAttachmentOptions (..)
  , EditAttachmentOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditAttachmentOptions = EditAttachmentOptions
  { browserDownloadUrl :: Text
  , name :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditAttachmentOptions where
  parseJSON = withObject "EditAttachmentOptions" $ \o ->
    EditAttachmentOptions
      <$> o .: "browser_download_url"
      <*> o .: "name"

instance ToJSON EditAttachmentOptions where
  toJSON = genericToJSON runOptions

data EditAttachmentOptionsPayload = EditAttachmentOptionsPayload
  { arpAction :: Text
  , arpRun :: EditAttachmentOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditAttachmentOptionsPayload where
  parseJSON = withObject "EditAttachmentOptionsPayload" $ \o ->
    EditAttachmentOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditAttachmentOptionsPayload where
  toJSON = genericToJSON arpOptions
