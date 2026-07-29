{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.FileLinksResponse
  ( FileLinksResponse (..)
  , FileLinksResponsePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data FileLinksResponse = FileLinksResponse
  { git :: Text
  , html :: Text
  , self :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON FileLinksResponse where
  parseJSON = withObject "FileLinksResponse" $ \o ->
    FileLinksResponse
      <$> o .: "git"
      <*> o .: "html"
      <*> o .: "self"

instance ToJSON FileLinksResponse where
  toJSON = genericToJSON runOptions

data FileLinksResponsePayload = FileLinksResponsePayload
  { arpAction :: Text
  , arpRun :: FileLinksResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON FileLinksResponsePayload where
  parseJSON = withObject "FileLinksResponsePayload" $ \o ->
    FileLinksResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON FileLinksResponsePayload where
  toJSON = genericToJSON arpOptions
