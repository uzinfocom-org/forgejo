module Forgejo.API.Commit
  ( CommitRoutes (..)
  ) where

import Data.Text (Text)
import Forgejo.Types.APIError (APIError)
import Forgejo.Types.APINotFound (APINotFound)
import Forgejo.Types.CommitStatus (CommitStatus)
import Forgejo.Types.CreateStatusOption (CreateStatusOption)
import GHC.Generics (Generic)
import Network.HTTP.Types (StdMethod (..))
import Servant (Capture, JSON, ReqBody, UVerb, WithStatus, type (:-), type (:>))

data CommitRoutes route = CommitRoutes
  { createCommitStatusApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "statuses"
          :> Capture "sha" Text
          :> ReqBody '[JSON] CreateStatusOption
          :> UVerb
               'POST
               '[JSON]
               '[ WithStatus 201 CommitStatus
                , WithStatus 400 APIError
                , WithStatus 404 APINotFound
                ]
  -- ^ POST /repos/{owner}/{repo}/statuses/{sha}
  }
  deriving stock (Generic)
