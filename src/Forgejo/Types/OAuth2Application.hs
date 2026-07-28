{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.OAuth2Application
  ( OAuth2Application (..)
  , OAuth2ApplicationPayload (..)
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

data OAuth2Application = OAuth2Application
  { cliendId :: Text
  , clientSecret :: Text
  , confidentialClient :: Bool
  , created :: UTCTime
  , id :: Int
  , name :: Text
  , redirectUris :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON OAuth2Application where
  parseJSON = withObject "OAuth2Application" $ \o ->
    OAuth2Application
      <$> o .: "client_id"
      <*> o .: "client_secret"
      <*> o .: "confidential_client"
      <*> o .: "created"
      <*> o .: "id"
      <*> o .: "name"
      <*> o .: "redirect_uris"

instance ToJSON OAuth2Application where
  toJSON = genericToJSON runOptions

data OAuth2ApplicationPayload = OAuth2ApplicationPayload
  { arpAction :: Text
  , arpRun :: OAuth2Application
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON OAuth2ApplicationPayload where
  parseJSON = withObject "OAuth2ApplicationPayload" $ \o ->
    OAuth2ApplicationPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON OAuth2ApplicationPayload where
  toJSON = genericToJSON arpOptions
