{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.QuotaUsedAttachment
  ( QuotaUsedAttachment (..)
  , QuotaUsedAttachmentPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data ContainedIn = ContainedIn
  { ciApiUrl :: Text
  , htmlUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

data QuotaUsedAttachment = QuotaUsedAttachment
  { quaApiUrl :: Text
  , containedIn :: ContainedIn
  , name :: Text
  , size :: Int
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ContainedIn where
  parseJSON = withObject "ContainedIn" $ \o ->
    ContainedIn
      <$> o .: "api_url"
      <*> o .: "html_url"

instance FromJSON QuotaUsedAttachment where
  parseJSON = withObject "QuotaUsedAttachment" $ \o ->
    QuotaUsedAttachment
      <$> o .: "api_url"
      <*> o .: "contained_in"
      <*> o .: "name"
      <*> o .: "size"

instance ToJSON ContainedIn where
  toJSON = genericToJSON runOptions

instance ToJSON QuotaUsedAttachment where
  toJSON = genericToJSON runOptions

data QuotaUsedAttachmentPayload = QuotaUsedAttachmentPayload
  { arpAction :: Text
  , arpRun :: QuotaUsedAttachment
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON QuotaUsedAttachmentPayload where
  parseJSON = withObject "QuotaUsedAttachmentPayload" $ \o ->
    QuotaUsedAttachmentPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON QuotaUsedAttachmentPayload where
  toJSON = genericToJSON arpOptions
