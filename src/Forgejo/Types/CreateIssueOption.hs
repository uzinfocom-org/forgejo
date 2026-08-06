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
  , cioRepo :: Text
  , cioApiJson :: CreateIssueApiOption
  }
  deriving stock (Eq, Generic, Show)

-- | This type is used as argument for body of endpoint 'createIssueApi'
data CreateIssueApiOption = CreateIssueApiOption
  { ciaoTitle :: Text
  , ciaoBody :: Maybe Text
  , ciaoAssignee :: Maybe User
  , ciaoAssigness :: [User]
  , ciaoClosed :: Maybe Bool
  , ciaoDueDate :: Maybe UTCTime
  , ciaoLabels :: Maybe LabelId
  , ciaoMilestone :: Maybe MilestoneId
  , ciaoRef :: Maybe Text
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreateIssueOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

instance ToJSON CreateIssueApiOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}
