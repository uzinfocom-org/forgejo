{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.NewIssuePinsAllowed
  ( NewIssuePinsAllowed (..)
  , NewIssuePinsAllowedPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data NewIssuePinsAllowed = NewIssuePinsAllowed
  { issues :: Bool
  , pullRequests :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON NewIssuePinsAllowed where
  parseJSON = withObject "NewIssuePinsAllowed" $ \o ->
    NewIssuePinsAllowed
      <$> o .: "issues"
      <*> o .: "pull_requests"

instance ToJSON NewIssuePinsAllowed where
  toJSON = genericToJSON runOptions

data NewIssuePinsAllowedPayload = NewIssuePinsAllowedPayload
  { arpAction :: Text
  , arpRun :: NewIssuePinsAllowed
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON NewIssuePinsAllowedPayload where
  parseJSON = withObject "NewIssuePinsAllowedPayload" $ \o ->
    NewIssuePinsAllowedPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON NewIssuePinsAllowedPayload where
  toJSON = genericToJSON arpOptions
