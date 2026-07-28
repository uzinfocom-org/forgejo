{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.DeleteEmailOption
  ( DeleteEmailOption (..)
  , DeleteEmailOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data DeleteEmailOption = DeleteEmailOption
  { emails :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON DeleteEmailOption where
  parseJSON = withObject "DeleteEmailOption" $ \o ->
    DeleteEmailOption
      <$> o .: "emails"

instance ToJSON DeleteEmailOption where
  toJSON = genericToJSON runOptions

data DeleteEmailOptionPayload = DeleteEmailOptionPayload
  { arpAction :: Text
  , arpRun :: DeleteEmailOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON DeleteEmailOptionPayload where
  parseJSON = withObject "DeleteEmailOptionPayload" $ \o ->
    DeleteEmailOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON DeleteEmailOptionPayload where
  toJSON = genericToJSON arpOptions
