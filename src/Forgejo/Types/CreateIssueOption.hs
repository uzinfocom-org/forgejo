{-# LANGUAGE DeriveGeneric #-}

module Forgejo.Types.CreateIssueOption
  ( CreateIssueOption (..)
  , CreateIssueApiOption (..)
  ) where

import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Common (LabelId (..), MilestoneId (..))
import Forgejo.Types.User (User (..))
import GHC.Generics (Generic)

-- | This type is used as argument for function 'createIssue'
data CreateIssueOption = CreateIssueOption
  { cioOwner :: Text
  -- ^ Owner ('User') of 'Issue'
  , cioRepo :: Text
  -- ^ 'Repository' of 'Issue'
  , cioApiJson :: CreateIssueApiOption
  -- ^ Body of API endpoint 'createIssueApi' of 'Issue'
  }
  deriving stock (Eq, Generic, Show)

-- | This type is used as argument for body of endpoint 'createIssueApi'
data CreateIssueApiOption = CreateIssueApiOption
  { ciaoTitle :: Text
  -- ^ Title of 'Issue'
  , ciaoBody :: Maybe Text
  -- ^ Body of 'Issue'
  , ciaoAssignees :: [User]
  -- ^ Assignees of 'Issue'
  , ciaoClosed :: Maybe Bool
  -- ^ Information about close of 'Issue'
  , ciaoDueDate :: Maybe UTCTime
  -- ^ Deadline of 'Issue'
  , ciaoLabels :: Maybe LabelId
  -- ^ Labels ('Label') of 'Issue'
  , ciaoMilestone :: Maybe MilestoneId
  -- ^ 'Milestone' of 'Issue'
  , ciaoRef :: Maybe Text
  -- ^ Reference of 'Issue'
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreateIssueOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

instance ToJSON CreateIssueApiOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}
