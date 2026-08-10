module Forgejo.API.Issue
  ( IssueRoutes (..)
  ) where

import Data.Text (Text)
import Forgejo.Types.Comment (Comment (..))
import Forgejo.Types.CreateIssueCommentOption
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.Issue (Issue)
import GHC.Generics (Generic)
import Servant (Capture, JSON, PostCreated, ReqBody, type (:-), type (:>))

data IssueRoutes route = IssueRoutes
  { createIssueApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "issues"
          :> ReqBody '[JSON] CreateIssueApiOption
          :> PostCreated '[JSON] [Issue]
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
          :> PostCreated '[JSON] Comment
  -- ^ POST /repos/{owner}/{repo}/issues/{index}/comments
  }
  deriving stock (Generic)
