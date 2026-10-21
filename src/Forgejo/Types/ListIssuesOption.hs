{-# LANGUAGE DeriveGeneric #-}

module Forgejo.Types.ListIssuesOption
  (
   ListIssuesOption (..)
  ) where

import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.API.Issue (IssueSortBy, IssueState, IssueType)
import GHC.Generics (Generic)

data ListIssuesOption = ListIssuesOption
  { lioOwner :: Text
    , lioRepo :: Text
    , lioState :: Maybe IssueState
    , lioLabels :: Maybe Text
    , lioQ :: Maybe Text
    , lioType :: Maybe IssueType
    , lioMilestone :: Maybe Text
    , lioSince :: Maybe UTCTime
    , lioBefore :: Maybe UTCTime
    , lioCreatedBy :: Maybe Text
    , lioAssignedBy :: Maybe Text
    , lioMentionedBy :: Maybe Text
    , lioLimit :: Maybe Int
    , lioPage :: Maybe Int
    , lioSort :: Maybe IssueSortBy
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON ListIssuesOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}
