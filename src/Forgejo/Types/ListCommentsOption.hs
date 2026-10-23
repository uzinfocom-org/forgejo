{-# LANGUAGE DeriveGeneric #-}

module Forgejo.Types.ListCommentsOption
  (
   ListCommentsOption (..)
  ) where

import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.API.Issue (IssueSortBy, IssueState, IssueType)
import GHC.Generics (Generic)

data ListCommentsOption = ListCommentsOption
  { lcoOwner :: Text
    , lcoRepo :: Text
    , lcoSince :: Maybe UTCTime
    , lcoBefore :: Maybe UTCTime
    , lcoLimit :: Maybe Int
    , lcoPage :: Maybe Int
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON ListCommentsOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}
