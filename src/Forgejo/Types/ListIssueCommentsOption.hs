{-# LANGUAGE DeriveGeneric #-}

module Forgejo.Types.ListIssueCommentsOption
  (
   ListIssueCommentsOption (..)
  ) where

import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.API.Issue (IssueSortBy, IssueState, IssueType)
import GHC.Generics (Generic)

data ListIssueCommentsOption = ListIssueCommentsOption
  { licoOwner :: Text
    , licoRepo :: Text
    , licoSince :: Maybe UTCTime
    , licoBefore :: Maybe UTCTime
    , licoLimit :: Maybe Int
    , licoPage :: Maybe Int
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON ListIssueCommentsOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}
