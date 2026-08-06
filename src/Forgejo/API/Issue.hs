{- HLINT ignore "Use newtype instead of data" -}
module Forgejo.API.Issue
  ( IssueRoutes (..)
  ) where

import Data.Text (Text)
import Forgejo.Types.CreateIssueOption (CreateIssueApiOption)
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
  }
  deriving (Generic)
