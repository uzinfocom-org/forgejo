-- | This module contains all issue related APIs.
module Forgejo.Methods.Issue
  ( createIssue
  , listIssues
  , searchIssues
  , getIssue
  , deleteIssue
  , createIssueComment
  , listIssueComments
  , getIssueComment
  , deleteIssueComment
  , editIssueComment
  ) where

import Forgejo.API (ForgejoRoutes (issues))
import Forgejo.API.Issue
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.Comment (Comment)
import Forgejo.Types.CreateIssueCommentOption
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.ListIssuesOption
import Forgejo.Types.EditIssueOption
import Forgejo.Types.SearchIssuesOption
import Forgejo.Types.ListIssueCommentsOption
import Forgejo.Types.EditIssueCommentOption
import Forgejo.Types.Issue (Issue)
import Data.Text (Text)
import Data.Int (Int64)
import Servant (NoContent)
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

{- | get an issue in a repository.

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
-}
getIssue :: Text -> Text -> Int64 -> AppM Issue
getIssue owner repo index = do
    fg <- forgejo
    getIssueApi (issues fg) owner repo index >>= liftResult

{- | edit an issue in a repository.

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
  * 'ErrForbidden': token lacks write access to issues
  * 'ErrPreconditionFailed': the condition defined by the If-Unmodified-Since or If-Match headers is not fulfilled
-}
editIssue :: Text -> Text -> Int64 -> EditIssueOption -> AppM Issue
editIssue owner repo index body = do
    fg <- forgejo
    editIssueApi (issues fg) owner repo index body >>= liftResult

{- | delete an issue in a repository.

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
  * 'ErrForbidden': token lacks write access to issues
-}
deleteIssue :: Text -> Text -> Int64 -> AppM NoContent
deleteIssue owner repo index = do
    fg <- forgejo
    deleteIssueApi (issues fg) owner repo index >>= liftResult

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

{- | List comments for issue

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
  * 'ErrValidation': title is empty, or label\/milestone IDs are invalid
  * 'ErrServer': internal server error occured
-}
listIssueComments :: ListIssueCommentsOption -> AppM [Comment]
listIssueComments ListIssueCommentsOption{..} = do
    fg <- forgejo
    listIssueCommentsApi (issues fg) licoOwner licoRepo licoSince licoBefore licoPage licoLimit >>= liftResult

{- | Get comment for issue

  Possible errors:

  * 'ErrForbidden': token lacks write access to issues
  * 'ErrNotFound': owner or repository does not exist
  * 'ErrServer': internal server error occured
-}
getIssueComment :: Text -> Text -> Int64 -> AppM Comment
getIssueComment owner repo id = do
    fg <- forgejo
    getIssueCommentApi (issues fg) owner repo id >>= liftResult

{- | Delete comment for issue

  Possible errors:

  * 'ErrForbidden': token lacks write access to issues
  * 'ErrNotFound': owner or repository does not exist
  * 'ErrServer': internal server error occured
-}
deleteIssueComment :: Text -> Text -> Int64 -> AppM NoContent
deleteIssueComment owner repo id = do
    fg <- forgejo
    deleteIssueCommentApi (issues fg) owner repo id >>= liftResult

{- | Delete comment for issue

  Possible errors:

  * 'ErrForbidden': token lacks write access to issues
  * 'ErrNotFound': owner or repository does not exist
  * 'ErrServer': internal server error occured
  * 'ErrRepoArchived': repository is archived
-}
editIssueComment :: Text -> Text -> Int64 -> EditIssueCommentOption -> AppM Comment
editIssueComment owner repo id body = do
    fg <- forgejo
    editIssueCommentApi (issues fg) owner repo id body >>= liftResult
