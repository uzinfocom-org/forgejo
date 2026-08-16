module Forgejo.API.Issue
  ( IssueRoutes (..)
  ) where

import Data.Text (Text)
import Forgejo.Types.APIError (APIError)
import Forgejo.Types.APIForbiddenError (APIForbiddenError)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.APIValidationError (APIValidationError)
import Forgejo.Types.Comment (Comment (..))
import Forgejo.Types.CreateIssueCommentOption
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.Issue (Issue)
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (Capture, JSON, ReqBody, UVerb, WithStatus, type (:-), type (:>))

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
                ]
  -- ^ POST /repos/{owner}/{repo}/issues
  , createIssueCommentApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> Capture "index" Int
          :> "comments"
          :> ReqBody '[JSON] CreateIssueCommentApiOption
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 201 Comment
                , WithStatus 403 APIForbiddenError
                , WithStatus 404 APINotFound
                , WithStatus 409 APIError
                , WithStatus 422 APIValidationError
                ]
  -- ^ POST /repos/{owner}/{repo}/issues/{index}/comments
  }
  deriving stock (Generic)
