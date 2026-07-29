{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.WikiPageMetaData
  ( WikiPageMetaData (..)
  , WikiPageMetaDataPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.WikiCommit (WikiCommit)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data WikiPageMetaData = WikiPageMetaData
  { htmlUrl :: Text
  , lastCommit :: WikiCommit
  , subUrl :: Text
  , title :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON WikiPageMetaData where
  parseJSON = withObject "WikiPageMetaData" $ \o ->
    WikiPageMetaData
      <$> o .: "html_url"
      <*> o .: "last_commit"
      <*> o .: "sub_url"
      <*> o .: "title"

instance ToJSON WikiPageMetaData where
  toJSON = genericToJSON runOptions

data WikiPageMetaDataPayload = WikiPageMetaDataPayload
  { arpAction :: Text
  , arpRun :: WikiPageMetaData
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON WikiPageMetaDataPayload where
  parseJSON = withObject "WikiPageMetaDataPayload" $ \o ->
    WikiPageMetaDataPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON WikiPageMetaDataPayload where
  toJSON = genericToJSON arpOptions
