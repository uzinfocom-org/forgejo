-- | This module contains all issue related APIs.
module Forgejo.Methods.Issue
  ( createIssue
  , listIssues
  , searchIssues
  , getIssue
  , deleteIssue
  , createIssueComment
  , listComments
  , getComment
  , deleteComment
  , editComment
  , listIssueLabels
  , createIssueLabels
  , deleteIssueLabels
  , deleteIssueLabelsIdentifier
  ) where

import Forgejo.App (AppM, forgejo)
import Forgejo.API (ForgejoRoutes (issues))
import Forgejo.API.Issue
import Forgejo.Error
import Forgejo.Types.Issue (Issue)
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.ListIssuesOption
import Forgejo.Types.EditIssueOption
import Forgejo.Types.SearchIssuesOption
import Forgejo.Types.Comment (Comment)
import Forgejo.Types.CreateIssueCommentOption
import Forgejo.Types.EditIssueCommentOption
import Forgejo.Types.ListCommentsOption
import Forgejo.Types.Label
import Forgejo.Types.IssueLabelsOption
import Forgejo.Types.DeleteLabelsOption
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
  createIssueCommentApi (issues fg) cicoOwner cicoRepo cicoIndex cicoApiJson >>= liftResult

{- | List comments for issue

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
  * 'ErrValidation': title is empty, or label\/milestone IDs are invalid
  * 'ErrServer': internal server error occured
-}
listComments :: ListCommentsOption -> AppM [Comment]
listComments ListCommentsOption{..} = do
    fg <- forgejo
    listCommentsApi (issues fg) lcoOwner lcoRepo lcoSince lcoBefore lcoPage lcoLimit >>= liftResult

{- | Get comment for issue

  Possible errors:

  * 'ErrForbidden': token lacks write access to issues
  * 'ErrNotFound': owner or repository does not exist
  * 'ErrServer': internal server error occured
-}
getComment :: Text -> Text -> Int64 -> AppM Comment
getComment owner repo id = do
    fg <- forgejo
    getCommentApi (issues fg) owner repo id >>= liftResult

{- | Delete comment for issue

  Possible errors:

  * 'ErrForbidden': token lacks write access to issues
  * 'ErrNotFound': owner or repository does not exist
  * 'ErrServer': internal server error occured
-}
deleteComment :: Text -> Text -> Int64 -> AppM NoContent
deleteComment owner repo id = do
    fg <- forgejo
    deleteCommentApi (issues fg) owner repo id >>= liftResult

{- | Delete comment for issue

  Possible errors:

  * 'ErrForbidden': token lacks write access to issues
  * 'ErrNotFound': owner or repository does not exist
  * 'ErrServer': internal server error occured
  * 'ErrRepoArchived': repository is archived
-}
editComment :: Text -> Text -> Int64 -> EditIssueCommentOption -> AppM Comment
editComment owner repo id body = do
    fg <- forgejo
    editCommentApi (issues fg) owner repo id body >>= liftResult


{- | list an issue's labels.

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
-}
listIssueLabels :: Text -> Text -> Int64 -> AppM [Label]
listIssueLabels owner repo index = do
    fg <- forgejo
    listIssueLabelsApi (issues fg) owner repo index >>= liftResult

{- | Replace an issue's labels.

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
  * 'ErrForbidden': token lacks write access to issues
-}
editIssueLabels :: Text -> Text -> Int64 -> IssueLabelsOption -> AppM [Label]
editIssueLabels owner repo index body = do
    fg <- forgejo
    editIssueLabelsApi (issues fg) owner repo index body >>= liftResult

{- | Create issue's labels.

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
  * 'ErrForbidden': token lacks write access to issues
-}
createIssueLabels :: Text -> Text -> Int64 -> IssueLabelsOption -> AppM [Label]
createIssueLabels owner repo index body = do
    fg <- forgejo
    createIssueLabelsApi (issues fg) owner repo index body >>= liftResult


{- | Delete issue's labels.

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
  * 'ErrForbidden': token lacks write access to issues
-}
deleteIssueLabels :: Text -> Text -> Int64 -> DeleteLabelsOption -> AppM NoContent
deleteIssueLabels owner repo index body = do
    fg <- forgejo
    deleteIssueLabelsApi (issues fg) owner repo index body >>= liftResult

{- | Delete label from an issue with identifier.

  Possible errors:

  * 'ErrNotFound': owner or repository does not exist
  * 'ErrForbidden': token lacks write access to issues
  * 'ErrValidation': title is empty, or label\/milestone IDs are invalid
-}
deleteIssueLabelsIdentifier :: Text -> Text -> Int64 -> Text -> DeleteLabelsOption -> AppM NoContent
deleteIssueLabelsIdentifier owner repo index identifier body = do
    fg <- forgejo
    deleteIssueLabelsIdentifierApi (issues fg) owner repo index identifier body >>= liftResult
