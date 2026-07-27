module Forgejo.Methods.PullRequest
  ( addReviewer
  ) where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (pulls))
import Forgejo.API.PullRequest (PullRequestRoutes (requestedReviews), PullReviewRequest, PullReviewRequestOptions (..))
import Forgejo.App (AppM, forgejo)

addReviewer :: Text -> Text -> Int -> [Text] -> [Text] -> AppM [PullReviewRequest]
addReviewer owner repo inx reviewers teamReviewers = do
  fg <- forgejo
  requestedReviews (pulls fg) owner repo inx $ PullReviewRequestOptions reviewers teamReviewers
