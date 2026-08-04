{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Forgejo.Types.Common
  ( UserId (..)
  , SourceId (..)
  , RepoId (..)
  , IssueId (..)
  , CommentId (..)
  , RunId (..)
  , ScheduleId (..)
  , PullRequestId (..)
  , LabelId (..)
  , MilestoneId (..)
  ) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Int (Int64)
import Web.HttpApiData (ToHttpApiData)

newtype UserId = UserId Int64
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToHttpApiData, ToJSON)

newtype SourceId = SourceId Int64
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToHttpApiData, ToJSON)

newtype RepoId = RepoId Int64
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToHttpApiData, ToJSON)

newtype IssueId = IssueId Int64
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToHttpApiData, ToJSON)

newtype CommentId = CommentId Int64
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToHttpApiData, ToJSON)

newtype RunId = RunId Int64
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToHttpApiData, ToJSON)

newtype ScheduleId = ScheduleId Int64
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToHttpApiData, ToJSON)

newtype PullRequestId = PullRequestId Int64
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToHttpApiData, ToJSON)

newtype LabelId = LabelId Int64
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToHttpApiData, ToJSON)

newtype MilestoneId = MilestoneId Int64
  deriving stock (Eq, Show)
  deriving newtype (FromJSON, ToHttpApiData, ToJSON)
