{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateWikiPageOptions
  ( CreateWikiPageOptions (..)
  , CreateWikiPageOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateWikiPageOptions = CreateWikiPageOptions
  { contentBase64 :: Text
  , message :: Text
  , title :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateWikiPageOptions where
  parseJSON = withObject "CreateWikiPageOptions" $ \o ->
    CreateWikiPageOptions
      <$> o .: "content_base64"
      <*> o .: "message"
      <*> o .: "title"

instance ToJSON CreateWikiPageOptions where
  toJSON = genericToJSON runOptions

data CreateWikiPageOptionsPayload = CreateWikiPageOptionsPayload
  { arpAction :: Text
  , arpRun :: CreateWikiPageOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateWikiPageOptionsPayload where
  parseJSON = withObject "CreateWikiPageOptionsPayload" $ \o ->
    CreateWikiPageOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateWikiPageOptionsPayload where
  toJSON = genericToJSON arpOptions
