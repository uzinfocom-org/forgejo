{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.FilesResponse
  ( FilesResponse (..)
  , FilesResponsePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.ContentsResponse (ContentsResponse)
import Forgejo.Types.FileCommitResponse (FileCommitResponse)
import Forgejo.Types.PayloadCommitVerification (PayloadCommitVerification)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data FilesResponse = FilesResponse
  { commit :: FileCommitResponse
  , content :: [ContentsResponse]
  , verification :: PayloadCommitVerification
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON FilesResponse where
  parseJSON = withObject "FilesResponse" $ \o ->
    FilesResponse
      <$> o .: "commit"
      <*> o .: "content"
      <*> o .: "verification"

instance ToJSON FilesResponse where
  toJSON = genericToJSON runOptions

data FilesResponsePayload = FilesResponsePayload
  { arpAction :: Text
  , arpRun :: FilesResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON FilesResponsePayload where
  parseJSON = withObject "FilesResponsePayload" $ \o ->
    FilesResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON FilesResponsePayload where
  toJSON = genericToJSON arpOptions
