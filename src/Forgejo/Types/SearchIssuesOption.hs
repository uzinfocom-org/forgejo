{-# LANGUAGE DeriveGeneric #-}

module Forgejo.Types.SearchIssuesOption(
   SearchIssuesOption (..)
  ) where

import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.API.Issue (IssueSortBy, IssueState, IssueType)
import GHC.Generics (Generic)
import Data.Int (Int64)

data SearchIssuesOption = SearchIssuesOption
  {
     sioState :: Maybe IssueState
    , sioLabels :: Maybe Text
    , sioMilestones :: Maybe Text
    , sioQ :: Maybe Text
    , sioPriorityRepoId :: Maybe Int64
    , sioType :: Maybe IssueType
    , sioSince :: Maybe UTCTime
    , sioBefore :: Maybe UTCTime
    , sioAssigned :: Maybe Bool
    , sioCreated :: Maybe Bool
    , sioMentioned :: Maybe Bool
    , sioReviewRequested :: Maybe Bool
    , sioReviewed :: Maybe Bool
    , sioOwner :: Maybe Text
    , sioTeam :: Maybe Text
    , sioPage :: Maybe Int
    , sioLimit :: Maybe Int
    , sioSort :: Maybe IssueSortBy
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON SearchIssuesOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}
