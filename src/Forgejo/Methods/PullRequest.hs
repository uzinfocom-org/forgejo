module Forgejo.Methods.PullRequest (PullReviewRequestOptions (..), addReviewer, createPullRequest)
where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (pulls))
import Forgejo.API.PullRequest
  ( PullRequestRoutes (createPullRequestApi, requestReviewsApi)
  , PullReviewRequest
  , PullReviewRequestApiOptions (..)
  )
import Forgejo.App (AppM, forgejo)
import Forgejo.Types.CreatePullRequestOption (CreatePullRequestOption)
import Forgejo.Types.PullRequest (PullRequest)
import GHC.Generics (Generic)

data PullReviewRequestOptions = PullReviewRequestOptions
  { owner :: Text
  , repo :: Text
  , index :: Int
  , reviewers :: [Text]
  , teamReviewers :: [Text]
  }
  deriving stock (Eq, Generic, Show)

createPullRequest :: Text -> Text -> CreatePullRequestOption -> AppM PullRequest
createPullRequest owner repo opts = do
  fg <- forgejo
  createPullRequestApi (pulls fg) owner repo opts

addReviewer :: PullReviewRequestOptions -> AppM [PullReviewRequest]
addReviewer PullReviewRequestOptions{..} = do
  fg <- forgejo
  requestReviewsApi (pulls fg) owner repo index $ PullReviewRequestApiOptions reviewers teamReviewers
