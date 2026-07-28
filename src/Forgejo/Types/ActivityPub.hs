{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ActivityPub
  ( ActivityPub (..)
  , ActivityPubPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

appOptions :: Options
appOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

apOptions :: Options
apOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

data ActivityPub = ActivityPub
  { apContext :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON ActivityPub where
  parseJSON = withObject "ActivityPub" $ \o ->
    ActivityPub
      <$> o .: "@context"

instance ToJSON ActivityPub where
  toJSON = genericToJSON apOptions

data ActivityPubPayload = ActivityPubPayload
  { arpAction :: Text
  , arpRun :: ActivityPub
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ActivityPubPayload where
  parseJSON = withObject "ActivityPubPayload" $ \o ->
    ActivityPubPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ActivityPubPayload where
  toJSON = genericToJSON appOptions
