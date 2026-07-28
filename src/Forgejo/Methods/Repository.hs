module Forgejo.Methods.Repository
  ( createRepository
  ) where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (repos))
import Forgejo.API.Repository (RepoRoutes (createRepositoryApi))
import Forgejo.App (AppM, forgejo)
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption (..))
import Forgejo.Types.Repository (Repository)

createRepository :: CreateRepositoryOption -> AppM [Repository]
createRepository c = do
  fg <- forgejo
  createRepositoryApi (repos fg) c
