module Forgejo.Methods.Issue
  ( createIssue
  , createIssueComment
  ) where

import Forgejo.API (ForgejoRoutes (issues))
import Forgejo.API.Issue (IssueRoutes (..))
import Forgejo.App (AppM, forgejo)
import Forgejo.Types.Comment (Comment)
import Forgejo.Types.CreateIssueCommentOption
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.Issue (Issue)

{- | This function creates issue on Forgejo via calling to endpoint 'createIssueApi' from 'IssueRoutes'.
It takes one argument of type 'CreateIssueOption'
-}
createIssue :: CreateIssueOption -> AppM [Issue]
createIssue CreateIssueOption{..} = do
  fg <- forgejo
  createIssueApi (issues fg) cioOwner cioRepo cioApiJson

{- | This function creates a comment on an issue/PR on Forgejo via calling to
endpoint 'createIssueCommentApi' from 'IssueRoutes'. Takes one argument of
type 'CreateIssueCommentOption'.
-}
createIssueComment :: CreateIssueCommentOption -> AppM Comment
createIssueComment CreateIssueCommentOption{..} = do
  fg <- forgejo
  createIssueCommentApi (issues fg) ciscoOwner ciscoRepo ciscoIndex ciscoApiJson
