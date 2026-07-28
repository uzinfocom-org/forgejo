{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GitBlob
  ( GitBlob (..)
  , GitBlobPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GitBlob = GitBlob
  { content :: Text
  , encoding :: Text
  , sha :: Text
  , size :: Int
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GitBlob where
  parseJSON = withObject "GitBlob" $ \o ->
    GitBlob
      <$> o .: "content"
      <*> o .: "encoding"
      <*> o .: "sha"
      <*> o .: "size"
      <*> o .: "url"

instance ToJSON GitBlob where
  toJSON = genericToJSON runOptions

data GitBlobPayload = GitBlobPayload
  { arpAction :: Text
  , arpRun :: GitBlob
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GitBlobPayload where
  parseJSON = withObject "GitBlobPayload" $ \o ->
    GitBlobPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GitBlobPayload where
  toJSON = genericToJSON arpOptions
