{-# LANGUAGE OverloadedRecordDot #-}

module Forgejo.Methods.Issue
  ( createIssue
  ) where

import Forgejo.API (ForgejoRoutes (issues))
import Forgejo.API.Issue (IssueRoutes (createIssueApi))
import Forgejo.App (AppM, forgejo)
import Forgejo.Types.CreateIssueOption
import Forgejo.Types.Issue (Issue)

createIssue :: CreateIssueOption -> AppM [Issue]
createIssue c = do
  fg <- forgejo
  createIssueApi (issues fg) owner repo apiJson
 where
  owner = c.cioOwner
  repo = c.cioRepo
  apiJson = c.cioApiJson
