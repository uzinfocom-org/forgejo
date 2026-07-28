{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateOAuth2ApplicationOptions
  ( CreateOAuth2ApplicationOptions (..)
  , CreateOAuth2ApplicationOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateOAuth2ApplicationOptions = CreateOAuth2ApplicationOptions
  { confidentialClient :: Bool
  , name :: Text
  , redirectUrls :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateOAuth2ApplicationOptions where
  parseJSON = withObject "CreateOAuth2ApplicationOptions" $ \o ->
    CreateOAuth2ApplicationOptions
      <$> o .: "confidential_client"
      <*> o .: "name"
      <*> o .: "redirect_urls"

instance ToJSON CreateOAuth2ApplicationOptions where
  toJSON = genericToJSON runOptions

data CreateOAuth2ApplicationOptionsPayload = CreateOAuth2ApplicationOptionsPayload
  { arpAction :: Text
  , arpRun :: CreateOAuth2ApplicationOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateOAuth2ApplicationOptionsPayload where
  parseJSON = withObject "CreateOAuth2ApplicationOptionsPayload" $ \o ->
    CreateOAuth2ApplicationOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateOAuth2ApplicationOptionsPayload where
  toJSON = genericToJSON arpOptions
