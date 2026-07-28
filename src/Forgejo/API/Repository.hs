module Forgejo.API.Repository
	  ( RepoRoutes (..)
	  ) where

	import Forgejo.Types.CreateRepositoryOption (CreateRepositoryOption)
	import Forgejo.Types.Repository (Repository)
	import GHC.Generics (Generic)
	import Servant (JSON, Post, ReqBody, type (:-), type (:>))

	data RepoRoutes route = RepoRoutes
	  { createRepositoryApi
	      :: route
	        :- "repos"
	          :> ReqBody '[JSON] CreateRepositoryOption
	          :> Post '[JSON] [Repository]
	  -- ^ POST /user/repos
	  }
	  deriving (Generic)
