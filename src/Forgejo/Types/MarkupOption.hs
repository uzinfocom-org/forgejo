{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.MarkupOption
  ( MarkupOption (..)
  , MarkupOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data MarkupOption = MarkupOption
  { branchPath :: Text
  , context :: Text
  , filePath :: Text
  , mode :: Text -- comment, gfm, markdown, file
  , text :: Text
  , wiki :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON MarkupOption where
  parseJSON = withObject "MarkupOption" $ \o ->
    MarkupOption
      <$> o .: "BranchPath"
      <*> o .: "Context"
      <*> o .: "FilePath"
      <*> o .: "Mode"
      <*> o .: "Text"
      <*> o .: "Wiki"

instance ToJSON MarkupOption where
  toJSON = genericToJSON runOptions

data MarkupOptionPayload = MarkupOptionPayload
  { arpAction :: Text
  , arpRun :: MarkupOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON MarkupOptionPayload where
  parseJSON = withObject "MarkupOptionPayload" $ \o ->
    MarkupOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON MarkupOptionPayload where
  toJSON = genericToJSON arpOptions
