{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.PullRequestCommit
  ( PullRequestCommit (..)
  , isMergeCommit
  ) where

import Data.Aeson (FromJSON (..), withObject, (.!=), (.:), (.:?))
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.User (User)

-- A commit as listed by GET /repos/{owner}/{repo}/pulls/{index}/commits.
-- Only the fields we use are decoded.
data PullRequestCommit = PullRequestCommit
  { pcSha1 :: Text -- FIXME: Implement newtype for Sha references (e.g. ShaRef)
  , pcAuthorUser :: Maybe User -- Nothing when the git email matches no Forgejo user
  , pcAuthorName :: Text
  , pcAuthoredAt :: UTCTime
  , pcParents :: [Text]
  }
  deriving stock (Eq, Show)

instance FromJSON PullRequestCommit where
  parseJSON = withObject "PullRequestCommit" \o -> do
    gitCommit <- o .: "commit"
    gitAuthor <- gitCommit .: "author"
    PullRequestCommit
      <$> o .: "sha"
      <*> o .:? "author"
      <*> gitAuthor .: "name"
      <*> gitAuthor .: "date"
      <*> (o .:? "parents" .!= [] >>= traverse (.: "sha"))

-- | Commit with more than one parent is merge commit, for example the one from "update branch" button.
isMergeCommit :: PullRequestCommit -> Bool
isMergeCommit = (> 1) . length . (.pcParents)
