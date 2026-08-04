module Forgejo.Types.IssueComment
  ( IssueCommentPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.Comment (Comment)
import Forgejo.Types.Issue (Issue)
import Forgejo.Types.PullRequest (PullRequest)
import Forgejo.Types.Repository (Repository)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

icOptions :: Options
icOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

data IssueCommentPayload = IssueCommentPayload
  { icAction :: Text
  , icIssue :: Issue
  , icPullRequest :: Maybe PullRequest
  , icComment :: Comment
  , icRepository :: Repository
  , icSender :: User
  , icIsPull :: Bool
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IssueCommentPayload where
  parseJSON = genericParseJSON icOptions
