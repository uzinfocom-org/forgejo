{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.FileDeleteResponse
  ( FileDeleteResponse (..)
  , FileDeleteResponsePayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.FileCommitResponse (FileCommitResponse)
import Forgejo.Types.PayloadCommitVerification (PayloadCommitVerification)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data FileDeleteResponse = FileDeleteResponse
  { commit :: FileCommitResponse
  , content :: ()
  , -- FIXME: It's empty in docs
    verification :: PayloadCommitVerification
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON FileDeleteResponse where
  parseJSON = withObject "FileDeleteResponse" $ \o ->
    FileDeleteResponse
      <$> o .: "commit"
      <*> o .: "content"
      <*> o .: "verification"

instance ToJSON FileDeleteResponse where
  toJSON = genericToJSON runOptions

data FileDeleteResponsePayload = FileDeleteResponsePayload
  { arpAction :: Text
  , arpRun :: FileDeleteResponse
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON FileDeleteResponsePayload where
  parseJSON = withObject "FileDeleteResponsePayload" $ \o ->
    FileDeleteResponsePayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON FileDeleteResponsePayload where
  toJSON = genericToJSON arpOptions
