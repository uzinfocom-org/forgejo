-- | This module contains all issue related APIs.
module Forgejo.Methods.Issue
  ( createIssue
  , createIssueComment
  ) where

import Forgejo.API (ForgejoRoutes (issues))
import Forgejo.API.Issue (IssueRoutes (..))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.Comment (Comment)
import Forgejo.Types.CreateIssueCommentOption
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.Issue (Issue)
import Data.Text (Text)
import Data.Time (UTCTime)
import Data.Int (Int64)

--

{- | Create an issue in a repository.

  Possible errors:

  * 'ErrForbidden': token lacks write access to issues
  * 'ErrNotFound': owner or repository does not exist
  * 'ErrConflict': issue with same reference already exists
  * 'ErrValidation': title is empty, or label\/milestone IDs are invalid
  * 'ErrRepoArchived': repository is archived
-}
createIssue :: CreateIssueOption -> AppM Issue
createIssue CreateIssueOption{..} = do
  fg <- forgejo
  createIssueApi (issues fg) cioOwner cioRepo cioApiJson >>= liftResult

searchIssue :: Maybe Text -> Maybe Text -> Maybe Text -> Maybe Text -> Maybe Int64 -> Maybe Text -> Maybe UTCTime -> Maybe UTCTime -> Maybe Bool -> Maybe Bool -> Maybe Bool -> Maybe Bool ->  Maybe Bool -> Maybe Text -> Maybe Text -> Maybe Int -> Maybe Int -> Maybe Text -> AppM [Issue]
searchIssue state labels milestones q priorityRepoId tayp since before assigned created mentioned review_requested reviewed owner team page limit sort = do
    fg <- forgejo
    searchIssueApi (issues fg) state labels milestones q priorityRepoId tayp since before assigned created mentioned review_requested reviewed owner team page limit sort >>= liftResult


{- | Create a comment for issues

  Possible errors:

  * 'ErrForbidden': token lacks write access to issues
  * 'ErrNotFound': owner or repository does not exist
  * 'ErrRepoArchived': repository is archived
  * 'ErrServer': internal server error occured
-}
createIssueComment :: CreateIssueCommentOption -> AppM Comment
createIssueComment CreateIssueCommentOption{..} = do
  fg <- forgejo
  createIssueCommentApi (issues fg) ciscoOwner ciscoRepo ciscoIndex ciscoApiJson >>= liftResult
