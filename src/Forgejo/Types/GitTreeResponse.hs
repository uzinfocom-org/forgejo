{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GitTreeResponse
  ( GitTreeResponse (..)
  , GitTreeResponsePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.GitEntry (GitEntry)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GitTreeResponse = GitTreeResponse
  { page :: Int
  , sha :: Text
  , totalCount :: Int
  , tree :: [GitEntry]
  , truncated :: Bool
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GitTreeResponse where
  parseJSON = withObject "GitTreeResponse" $ \o ->
    GitTreeResponse
      <$> o .: "page"
      <*> o .: "sha"
      <*> o .: "total_count"
      <*> o .: "tree"
      <*> o .: "truncated"
      <*> o .: "url"

instance ToJSON GitTreeResponse where
  toJSON = genericToJSON runOptions

data GitTreeResponsePayload = GitTreeResponsePayload
  { arpAction :: Text
  , arpRun :: GitTreeResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GitTreeResponsePayload where
  parseJSON = withObject "GitTreeResponsePayload" $ \o ->
    GitTreeResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GitTreeResponsePayload where
  toJSON = genericToJSON arpOptions
