{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.FileResponse
  ( FileResponse (..)
  , FileResponsePayload (..)
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

data FileResponse = FileResponse
  { commit :: FileCommitResponse
  , content :: ContentsResponse
  , verification :: PayloadCommitVerification
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON FileResponse where
  parseJSON = withObject "FileResponse" $ \o ->
    FileResponse
      <$> o .: "commit"
      <*> o .: "content"
      <*> o .: "verification"

instance ToJSON FileResponse where
  toJSON = genericToJSON runOptions

data FileResponsePayload = FileResponsePayload
  { arpAction :: Text
  , arpRun :: FileResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON FileResponsePayload where
  parseJSON = withObject "FileResponsePayload" $ \o ->
    FileResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON FileResponsePayload where
  toJSON = genericToJSON arpOptions
