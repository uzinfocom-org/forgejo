{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.DeleteLabelsOption
  ( DeleteLabelsOption (..)
  , DeleteLabelsOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data DeleteLabelsOption = DeleteLabelsOption
  { updatedAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON DeleteLabelsOption where
  parseJSON = withObject "DeleteLabelsOption" $ \o ->
    DeleteLabelsOption
      <$> o .: "updated_at"

instance ToJSON DeleteLabelsOption where
  toJSON = genericToJSON runOptions

data DeleteLabelsOptionPayload = DeleteLabelsOptionPayload
  { arpAction :: Text
  , arpRun :: DeleteLabelsOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON DeleteLabelsOptionPayload where
  parseJSON = withObject "DeleteLabelsOptionPayload" $ \o ->
    DeleteLabelsOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON DeleteLabelsOptionPayload where
  toJSON = genericToJSON arpOptions
