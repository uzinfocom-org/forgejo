-- | This module contains all issue related APIs.
module Forgejo.Methods.Issue
  ( createIssue
  , listIssues
  , searchIssues
  , createIssueComment
  , listIssueComments
  ) where

import Forgejo.API (ForgejoRoutes (issues))
import Forgejo.API.Issue (IssueSortBy, IssueState, IssueType, IssueRoutes (..))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.Comment (Comment)
import Forgejo.Types.CreateIssueCommentOption
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.ListIssuesOption
import Forgejo.Types.SearchIssuesOption
import Forgejo.Types.ListIssueCommentsOption
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


{- | list issues in a repository.

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
  * 'ErrValidation': title is empty, or label\/milestone IDs are invalid
-}
listIssues :: ListIssuesOption -> AppM [Issue]
listIssues ListIssuesOption{..} = do
    fg <- forgejo
    listIssuesApi (issues fg) lioOwner lioRepo lioState lioLabels lioQ lioType lioMilestone lioSince lioBefore lioCreatedBy lioAssignedBy lioMentionedBy lioPage lioLimit lioSort >>= liftResult

{- | Search an issue in a repository.

  Possible errors:

  * 'ErrApi: Bad Request
  * 'ErrValidation': title is empty, or label\/milestone IDs are invalid
-}
searchIssues :: SearchIssuesOption -> AppM [Issue]
searchIssues SearchIssuesOption{..} = do
    fg <- forgejo
    searchIssuesApi (issues fg) sioState sioLabels sioMilestones sioQ sioPriorityRepoId sioType sioSince sioBefore sioAssigned sioCreated sioMentioned sioReviewRequested sioReviewed sioOwner sioTeam sioPage sioLimit sioSort >>= liftResult
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

listIssueComments :: ListIssueCommentsOption -> AppM [Comment]
listIssueComments ListIssueCommentsOption{..} = do
    fg <- forgejo
    listIssueCommentsApi (issues fg) licoOwner licoRepo licoSince licoBefore licoPage licoLimit >>= liftResult
