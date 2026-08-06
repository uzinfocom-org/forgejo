{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ContentsResponse
  ( ContentsResponse (..)
  , ContentsResponsePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.FileLinksResponse (FileLinksResponse)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CType = File | Dir | Symlink | Submodule
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data ContentsResponse = ContentsResponse
  { _links :: FileLinksResponse
  , content :: Text
  , downloadUrl :: Text
  , encoding :: Text
  , gitUrl :: Text
  , htmlUrl :: Text
  , lastCommitSha :: Text
  , lastCommitWhen :: UTCTime
  , name :: Text
  , path :: Text
  , sha :: Text
  , size :: Int
  , submoduleGitUrl :: Text
  , target :: Text
  , cType :: CType
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ContentsResponse where
  parseJSON = withObject "ContentsResponse" $ \o ->
    ContentsResponse
      <$> o .: "_links"
      <*> o .: "content"
      <*> o .: "download_url"
      <*> o .: "encoding"
      <*> o .: "git_url"
      <*> o .: "html_url"
      <*> o .: "last_commit_sha"
      <*> o .: "last_commit_when"
      <*> o .: "name"
      <*> o .: "path"
      <*> o .: "sha"
      <*> o .: "size"
      <*> o .: "submodule_git_url"
      <*> o .: "target"
      <*> o .: "type"
      <*> o .: "url"

instance ToJSON ContentsResponse where
  toJSON = genericToJSON runOptions

data ContentsResponsePayload = ContentsResponsePayload
  { arpAction :: Text
  , arpRun :: ContentsResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ContentsResponsePayload where
  parseJSON = withObject "ContentsResponsePayload" $ \o ->
    ContentsResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ContentsResponsePayload where
  toJSON = genericToJSON arpOptions
