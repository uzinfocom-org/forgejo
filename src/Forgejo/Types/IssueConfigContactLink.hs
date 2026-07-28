{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.IssueConfigContactLink
  ( IssueConfigContactLink (..)
  , IssueConfigContactLinkPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data IssueConfigContactLink = IssueConfigContactLink
  { about :: Text
  , name :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON IssueConfigContactLink where
  parseJSON = withObject "IssueConfigContactLink" $ \o ->
    IssueConfigContactLink
      <$> o .: "about"
      <*> o .: "name"
      <*> o .: "url"

instance ToJSON IssueConfigContactLink where
  toJSON = genericToJSON runOptions

data IssueConfigContactLinkPayload = IssueConfigContactLinkPayload
  { arpAction :: Text
  , arpRun :: IssueConfigContactLink
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IssueConfigContactLinkPayload where
  parseJSON = withObject "IssueConfigContactLinkPayload" $ \o ->
    IssueConfigContactLinkPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON IssueConfigContactLinkPayload where
  toJSON = genericToJSON arpOptions
