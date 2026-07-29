{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.IssueConfig
  ( IssueConfig (..)
  , IssueConfigPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.IssueConfigContactLink (IssueConfigContactLink)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data IssueConfig = IssueConfig
  { blankIssuesEnabled :: Bool
  , contactLinks :: [IssueConfigContactLink]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON IssueConfig where
  parseJSON = withObject "IssueConfig" $ \o ->
    IssueConfig
      <$> o .: "blankIssueEnabled"
      <*> o .: "contact_links"

instance ToJSON IssueConfig where
  toJSON = genericToJSON runOptions

data IssueConfigPayload = IssueConfigPayload
  { arpAction :: Text
  , arpRun :: IssueConfig
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IssueConfigPayload where
  parseJSON = withObject "IssueConfigPayload" $ \o ->
    IssueConfigPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON IssueConfigPayload where
  toJSON = genericToJSON arpOptions
