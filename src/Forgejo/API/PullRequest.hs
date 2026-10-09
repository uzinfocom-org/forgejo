module Forgejo.API.PullRequest
  ( PullRequestRoutes (..)
  , PullReviewRequestApiOptions (..)
  , PullReviewRequest (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.APIError (APIError)
import Forgejo.Types.APIForbiddenError (APIForbiddenError)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.APIValidationError (APIValidationError)
import Forgejo.Types.ChangedFile (ChangedFile)
import Forgejo.Types.CreatePullRequestOption (CreatePullRequestOption)
import Forgejo.Types.PullRequest (PullRequest)
import Forgejo.Types.PullRequestCommit (PullRequestCommit)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (Capture, JSON, QueryParam, ReqBody, UVerb, WithStatus, type (:-), type (:>))

data PullRequestRoutes route = PullRequestRoutes
  { requestReviewsApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "pulls"
          :> Capture "index" Int
          :> "requested_reviewers"
          :> ReqBody '[JSON] PullReviewRequestApiOptions
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 201 [PullReviewRequest]
                , WithStatus 422 APIValidationError
                ]
  -- ^ POST /repos/{owner}/{repo}/pulls/{index}/requested_reviewers
  , createPullRequestApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "pulls"
          :> ReqBody '[JSON] CreatePullRequestOption
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 201 PullRequest
                , WithStatus 403 APIForbiddenError
                , WithStatus 404 APINotFound
                , WithStatus 409 APIError
                , WithStatus 422 APIValidationError
                ]
  -- ^ POST /repos/{owner}/{repo}/pulls
  , listPullRequestFilesApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "pulls"
          :> Capture "index" Int
          :> "files"
          :> QueryParam "skip-to" Text
          :> QueryParam "whitespace" Text
          :> QueryParam "page" Int
          :> QueryParam "limit" Int
          :> UVerb
               'GET
               '[JSON]
               '[ WithStatus 200 (Maybe [ChangedFile])
                , WithStatus 404 APINotFound
                ]
  -- ^ GET /repos/{owner}/{repo}/pulls/{index}/files
  , listPullRequestCommitsApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "pulls"
          :> Capture "index" Int
          :> "commits"
          :> QueryParam "page" Int
          :> QueryParam "limit" Int
          :> QueryParam "verification" Bool
          :> QueryParam "files" Bool
          :> UVerb
               'GET
               '[JSON]
               '[ WithStatus 200 [PullRequestCommit]
                , WithStatus 404 APINotFound
                , WithStatus 409 APIError
                ]
  -- ^ GET /repos/{owner}/{repo}/pulls/{index}/commits
  }
  deriving stock (Generic)

data PullReviewRequestApiOptions = PullReviewRequestApiOptions
  { reviewers :: [Text]
  , teamReviewers :: [Text]
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON PullReviewRequestApiOptions where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_'}

newtype PullReviewRequest = PullReviewRequest
  { pullReviewRequestUser :: Maybe User
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PullReviewRequest where
  parseJSON = genericParseJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 17}
