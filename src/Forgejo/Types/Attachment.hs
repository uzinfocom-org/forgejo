{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Attachment
  ( Attachment (..)
  , AttachmentType (..)
  , WebAttachment (..)
  , EditAttachmentOptions (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Int (Int64)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Common (AttachmentId (..))
import GHC.Generics (Generic)

aOptions :: Options
aOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 1}

waOptions :: Options
waOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

eaOptions :: Options
eaOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data AttachmentType = Attachmentt | External
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data Attachment = Attachment
  { aId :: AttachmentId
  , aName :: Text
  , aSize :: Int64
  , aDownloadCount :: Int64
  , aCreated :: UTCTime
  , aUuid :: Text
  , aDownloadUrl :: Text
  , aType :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Attachment where
  parseJSON = genericParseJSON aOptions

instance ToJSON Attachment where
  toJSON = genericToJSON aOptions

data WebAttachment = WebAttachment
  { waAttachment :: Attachment
  , waMimeType :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON WebAttachment where
  parseJSON = genericParseJSON waOptions

instance ToJSON WebAttachment where
  toJSON = genericToJSON waOptions

data EditAttachmentOptions = EditAttachmentOptions
  { eaName :: Text
  , eaDownloadUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditAttachmentOptions where
  parseJSON = genericParseJSON eaOptions

instance ToJSON EditAttachmentOptions where
  toJSON = genericToJSON eaOptions
