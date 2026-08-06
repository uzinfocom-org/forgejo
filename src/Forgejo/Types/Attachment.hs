{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Attachment
  ( Attachment (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

aOptions :: Options
aOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data AttachmentType = Attachmentt | External
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data Attachment = Attachment
  { aBrowserDownloadUrl :: Text
  , aCreatedAt :: UTCTime
  , aDownloadCount :: Int
  , aId :: Int
  , aName :: Text
  , aSize :: Int
  , aType :: AttachmentType
  , aUuid :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Attachment where
  parseJSON = genericParseJSON aOptions
