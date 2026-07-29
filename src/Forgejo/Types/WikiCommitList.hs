{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.WikiCommitList
  ( WikiCommitList (..)
  , WikiCommitListPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.WikiCommit (WikiCommit)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data WikiCommitList = WikiCommitList
  { commits :: [WikiCommit]
  , count :: Int
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON WikiCommitList where
  parseJSON = withObject "WikiCommitList" $ \o ->
    WikiCommitList
      <$> o .: "commits"
      <*> o .: "count"

instance ToJSON WikiCommitList where
  toJSON = genericToJSON runOptions

data WikiCommitListPayload = WikiCommitListPayload
  { arpAction :: Text
  , arpRun :: WikiCommitList
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON WikiCommitListPayload where
  parseJSON = withObject "WikiCommitListPayload" $ \o ->
    WikiCommitListPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON WikiCommitListPayload where
  toJSON = genericToJSON arpOptions
