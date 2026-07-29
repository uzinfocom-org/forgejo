module Forgejo.API.Organization
  ( OrgRoutes (..)
  ) where

import Data.Text (Text)
import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption)
import Forgejo.Types.Repository (Repository)
import GHC.Generics (Generic)
import Servant (Capture, JSON, Post, ReqBody, type (:-), type (:>))

data OrgRoutes route = OrgRoutes
  { createOrgRepositoryApi
      :: route
        :- "org"
          :> Capture "org" Text
          :> "repos"
          :> ReqBody '[JSON] CreateRepositoryOption
          :> Post '[JSON] [Repository]
  -- ^ POST /orgs/{org}/repos
  }
  deriving (Generic)
