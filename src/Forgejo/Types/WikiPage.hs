{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.WikiPage
  ( WikiPage (..)
  , WikiPagePayload (..)
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

data WikiPage = WikiPage
  { commitCount :: Int
  , contentBase64 :: Text
  , footer :: Text
  , htmlUrl :: Text
  , lastCommit :: WikiCommit
  , sidebar :: Text
  , subUrl :: Text
  , title :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON WikiPage where
  parseJSON = withObject "WikiPage" $ \o ->
    WikiPage
      <$> o .: "commit_count"
      <*> o .: "content_base64"
      <*> o .: "footer"
      <*> o .: "html_url"
      <*> o .: "last_commit"
      <*> o .: "sidebar"
      <*> o .: "sub_url"
      <*> o .: "title"

instance ToJSON WikiPage where
  toJSON = genericToJSON runOptions

data WikiPagePayload = WikiPagePayload
  { arpAction :: Text
  , arpRun :: WikiPage
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON WikiPagePayload where
  parseJSON = withObject "WikiPagePayload" $ \o ->
    WikiPagePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON WikiPagePayload where
  toJSON = genericToJSON arpOptions
