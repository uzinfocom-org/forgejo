module Forgejo.API.Issue
  ( IssueSortBy
  , IssueState
  , IssueType
  , IssueRoutes (..)
  ) where

import Data.Text (Text, toLower)
import Data.Text qualified as T
import Forgejo.Types.APIError (APIError)
import Forgejo.Types.APIForbiddenError (APIForbiddenError)
import Forgejo.Types.APIInternalServerError (APIInternalServerError)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.APIRepoArchivedError (APIRepoArchivedError)
import Forgejo.Types.APIValidationError (APIValidationError)
import Forgejo.Types.APIPreconditionFailed (APIPreconditionFailed)
import Forgejo.Types.Comment (Comment (..))
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.EditIssueOption
import Forgejo.Types.CreateIssueCommentOption
import Forgejo.Types.EditIssueCommentOption
import Forgejo.Types.Issue (Issue)
import Forgejo.Types.Label
import Forgejo.Types.IssueLabelsOption
import Forgejo.Types.DeleteLabelsOption
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (Capture, JSON, QueryParam, ReqBody, NoContent, DeleteNoContent, UVerb, Verb, WithStatus,ToHttpApiData (..), type (:-), type (:>), type (:<|>))
import Data.Time (UTCTime)
import Data.Int (Int64)
import Data.Aeson (ToJSON, FromJSON)


data IssueSortBy = Relevance | Latest | Oldest | Recentupdate | Leastupdate | Mostcomment | Leastcomment | Nearduedate | Farduedate
    deriving (Eq, Show, Generic)
instance ToJSON IssueSortBy


deriving instance FromJSON NoContent
-- deriving instance Generic NoContent


instance ToHttpApiData IssueSortBy where
    toQueryParam :: IssueSortBy -> Text
    toQueryParam = toLower . T.pack . show

    -- toUrlPiece :: IssueSortBy -> Text
    -- toUrlPiece = toLower . T.pack . show

data IssueState = Open | Closed | All
    deriving (Eq, Show, Generic)
instance ToJSON IssueState

instance ToHttpApiData IssueState where
    toQueryParam :: IssueState -> Text
    toQueryParam = toLower . T.pack . show

data IssueType = Issues | Pulls
    deriving (Eq, Show, Generic)
instance ToJSON IssueType

instance ToHttpApiData IssueType where
    toQueryParam :: IssueType -> Text
    toQueryParam = toLower . T.pack . show


data IssueRoutes route = IssueRoutes
  { createIssueApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> ReqBody '[JSON] CreateIssueApiOption
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 201 Issue
                , WithStatus 403 APIForbiddenError
                , WithStatus 404 APINotFound
                , WithStatus 409 APIError
                , WithStatus 422 APIValidationError
                , WithStatus 423 APIRepoArchivedError
                ]
     -- ^ POST /repos/{owner}/{repo}/issues

    , listIssuesApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> QueryParam "state" IssueState
          :> QueryParam "labels" Text
          :> QueryParam "q" Text
          :> QueryParam "type" IssueType
          :> QueryParam "milestone" Text
          :> QueryParam "since" UTCTime
          :> QueryParam "before" UTCTime
          :> QueryParam "created_by" Text
          :> QueryParam "assigned_by" Text
          :> QueryParam "mentioned_by" Text
          :> QueryParam "page" Int
          :> QueryParam "limit" Int
          :> QueryParam "sort" IssueSortBy
          :> UVerb
            'GET
            '[JSON]
            '[
                WithStatus 200 [Issue],
                WithStatus 404 APINotFound,
                WithStatus 422 APIValidationError
            ]
    -- ^ GET /repos/{owner}/{repo}/issues

    , searchIssuesApi
      :: route
        :- "repos"
        :> "search"
          :> QueryParam "state" IssueState
          :> QueryParam "labels" Text
          :> QueryParam "milestones" Text
          :> QueryParam "q" Text
          :> QueryParam "priority_repo_id" Int64
          :> QueryParam "type" IssueType
          :> QueryParam "since" UTCTime
          :> QueryParam "before" UTCTime
          :> QueryParam "assigned" Bool
          :> QueryParam "created" Bool
          :> QueryParam "mentioned" Bool
          :> QueryParam "review_requested" Bool
          :> QueryParam "reviewed" Bool
          :> QueryParam "owner" Text
          :> QueryParam "team" Text
          :> QueryParam "page" Int
          :> QueryParam "limit" Int
          :> QueryParam "sort" IssueSortBy
          :> UVerb
            'GET
            '[JSON]
            '[
                WithStatus 200 [Issue],
                WithStatus 400 APIError,
                WithStatus 422 APIValidationError
            ]
    -- ^ GET /repos/issues/search

    , getIssueApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> Capture "index" Int64
          :> UVerb
              'GET
              '[JSON]
              '[
                  WithStatus 200 Issue,
                  WithStatus 404 APINotFound
              ]
    -- ^ GET /repos/{owner}/{repo}/issues/{index}

    , editIssueApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> Capture "index" Int64
          :> ReqBody '[JSON] EditIssueOption
          :> UVerb
              'PATCH
              '[JSON]
              '[
                  WithStatus 201 Issue,
                  WithStatus 403 APIForbiddenError,
                  WithStatus 404 APINotFound,
                  -- In forgejo this error is used as APIError, but this code is considered Precondition error
                  WithStatus 412 APIPreconditionFailed
              ]
    -- ^ PATCH /repos/{owner}/{repo}/issues/{index}

    , deleteIssueApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> Capture "index" Int64
          :> UVerb
              'DELETE
              '[JSON]
              '[
                  WithStatus 204 NoContent,
                  WithStatus 403 APIForbiddenError,
                  WithStatus 404 APINotFound
              ]
    -- ^ DELETE /repos/{owner}/{repo}/issues/{index}

    , listCommentsApi
    :: route
      :- "repos"
        :> Capture "owner" Text
        :> Capture "repo" Text
        :> "issues"
        :> "comments"
        :> QueryParam "since" UTCTime
        :> QueryParam "before" UTCTime
        :> QueryParam "page" Int
        :> QueryParam "limit" Int
        :> UVerb
            'GET
            '[JSON]
            '[
                WithStatus 200 [Comment],
                WithStatus 404 APINotFound,
                WithStatus 422 APIValidationError,
                WithStatus 500 APIInternalServerError
            ]
    -- ^ GET /repos/{owner}/{repo}/issues/comments

    , getCommentApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> "comments"
          :> Capture "id" Int64
          :> UVerb
              'GET
              '[JSON]
              '[
                  WithStatus 200 Comment,
                  -- TODO: need to make 204 status code work with `WithStatus` without writing instance of APIForgejoError for it
                  WithStatus 204 NoContent,
                  WithStatus 403 APIForbiddenError,
                  WithStatus 404 APINotFound,
                  WithStatus 500 APIInternalServerError
              ]
    -- ^ GET /repos/{owner}/{repo}/issues/comments/{id}

    , deleteCommentApi
      :: route
        :- "repos"
            :> Capture "owner" Text
            :> Capture "repo" Text
            :> "issues"
            :> "comments"
            :> Capture "id" Int64
            :> (UVerb
                'DELETE
                '[JSON]
                '[
                    WithStatus 204 NoContent,
                    WithStatus 403 APIForbiddenError,
                    WithStatus 500 APIInternalServerError
                ]
            )
    -- ^ DELETE /repos/{owner}/{repo}/issues/comments/{id}

    , editCommentApi
        :: route
            :- "repos"
              :> Capture "owner" Text
              :> Capture "repo" Text
              :> "issues"
              :> "comments"
              :> Capture "id" Int64
              :> ReqBody '[JSON] EditIssueCommentOption
              :> (UVerb
                  'PATCH
                  '[JSON]
                  '[
                      WithStatus 200 Comment,
                      WithStatus 204 NoContent,
                      WithStatus 403 APIForbiddenError,
                      WithStatus 404 APINotFound,
                      WithStatus 423 APIRepoArchivedError,
                      WithStatus 500 APIInternalServerError
                  ]
              )
    -- ^ PATCH /repos/{owner}/{repo}/issues/comments/{id}

    , createIssueCommentApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> Capture "index" Int64
          :> "comments"
          :> ReqBody '[JSON] CreateIssueCommentApiOption
          :> UVerb
            'POST
            '[JSON]
            '[
                WithStatus 201 Comment
              , WithStatus 403 APIForbiddenError
              , WithStatus 404 APINotFound
              , WithStatus 423 APIRepoArchivedError
              , WithStatus 500 APIInternalServerError
             ]
    -- ^ POST /repos/{owner}/{repo}/issues/{index}/comments

    , listIssueLabelsApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> Capture "index" Int64
          :> "labels"
          :> UVerb
            'GET
            '[JSON]
            '[
                WithStatus 200 [Label]
              , WithStatus 404 APINotFound
             ]
    -- ^ GET /repos/{owner}/{repo}/issues/{index}/labels

    , editIssueLabelsApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> Capture "index" Int64
          :> "labels"
          :> ReqBody '[JSON] IssueLabelsOption
          :> UVerb
            'PUT
            '[JSON]
            '[
                WithStatus 200 [Label]
              , WithStatus 403 APIForbiddenError
              , WithStatus 404 APINotFound
             ]
    -- ^ PUT /repos/{owner}/{repo}/issues/{index}/labels

    , createIssueLabelsApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> Capture "index" Int64
          :> "labels"
          :> ReqBody '[JSON] IssueLabelsOption
          :> UVerb
            'POST
            '[JSON]
            '[
                WithStatus 200 [Label]
              , WithStatus 403 APIForbiddenError
              , WithStatus 404 APINotFound
             ]
    -- ^ POST /repos/{owner}/{repo}/issues/{index}/labels

    , deleteIssueLabelsApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> Capture "index" Int64
          :> "labels"
          :> ReqBody '[JSON] DeleteLabelsOption
          :> UVerb
            'DELETE
            '[JSON]
            '[
                WithStatus 204 NoContent
              , WithStatus 403 APIForbiddenError
              , WithStatus 404 APINotFound
             ]
    -- ^ DELETE /repos/{owner}/{repo}/issues/{index}/labels
  }
  deriving stock (Generic)
