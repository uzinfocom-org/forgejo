{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.FileCommitResponse
  ( FileCommitResponse (..)
  , FileCommitResponsePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.CommitMeta (CommitMeta)
import Forgejo.Types.CommitUser (CommitUser)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data FileCommitResponse = FileCommitResponse
  { author :: CommitUser
  , committer :: CommitUser
  , created :: UTCTime
  , htmlUrl :: Text
  , parents :: [CommitMeta]
  , sha :: Text
  , tree :: CommitMeta
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON FileCommitResponse where
  parseJSON = withObject "FileCommitResponse" $ \o ->
    FileCommitResponse
      <$> o .: "author"
      <*> o .: "committer"
      <*> o .: "created"
      <*> o .: "html_url"
      <*> o .: "parents"
      <*> o .: "sha"
      <*> o .: "tree"
      <*> o .: "url"

instance ToJSON FileCommitResponse where
  toJSON = genericToJSON runOptions

data FileCommitResponsePayload = FileCommitResponsePayload
  { arpAction :: Text
  , arpRun :: FileCommitResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON FileCommitResponsePayload where
  parseJSON = withObject "FileCommitResponsePayload" $ \o ->
    FileCommitResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON FileCommitResponsePayload where
  toJSON = genericToJSON arpOptions
