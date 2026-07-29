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
createIssue CreateIssueOption{..} = do
  fg <- forgejo
  createIssueApi (issues fg) cioOwner cioRepo cioApiJson
