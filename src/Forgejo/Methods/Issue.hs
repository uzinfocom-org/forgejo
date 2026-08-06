module Forgejo.Methods.Issue
  ( createIssue
  ) where

import Forgejo.API (ForgejoRoutes (issues))
import Forgejo.API.Issue (IssueRoutes (createIssueApi))
import Forgejo.App (AppM, forgejo)
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.Issue (Issue)

{- | This function creates issue on Forgejo via calling to endpoint 'createIssueApi' from 'IssueRoutes'.
It takes one argument of type 'CreateIssueOption'
-}
createIssue :: CreateIssueOption -> AppM [Issue]
createIssue CreateIssueOption{..} = do
  fg <- forgejo
  createIssueApi (issues fg) cioOwner cioRepo cioApiJson
