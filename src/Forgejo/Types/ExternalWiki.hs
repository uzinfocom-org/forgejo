{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ExternalWiki
  ( ExternalWiki (..)
  , ExternalWikiPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data ExternalWiki = ExternalWiki
  { externalWikiUrl :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ExternalWiki where
  parseJSON = withObject "ExternalWiki" $ \o ->
    ExternalWiki
      <$> o .: "external_wiki_url"

instance ToJSON ExternalWiki where
  toJSON = genericToJSON runOptions

data ExternalWikiPayload = ExternalWikiPayload
  { arpAction :: Text
  , arpRun :: ExternalWiki
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ExternalWikiPayload where
  parseJSON = withObject "ExternalWikiPayload" $ \o ->
    ExternalWikiPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ExternalWikiPayload where
  toJSON = genericToJSON arpOptions
