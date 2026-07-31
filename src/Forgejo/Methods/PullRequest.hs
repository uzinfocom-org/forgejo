module Forgejo.Methods.PullRequest (PullReviewRequestOptions (..), addReviewer)
where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (pulls))
import Forgejo.API.PullRequest
  ( PullRequestRoutes (requestedReviews)
  , PullReviewRequest
  , PullReviewRequestApiOptions (..)
  )
import Forgejo.App (AppM, forgejo)
import GHC.Generics (Generic)

data PullReviewRequestOptions = PullReviewRequestOptions
  { owner :: Text
  , repo :: Text
  , index :: Int
  , reviewers :: [Text]
  , teamReviewers :: [Text]
  }
  deriving (Eq, Generic, Show)

addReviewer :: PullReviewRequestOptions -> AppM [PullReviewRequest]
addReviewer PullReviewRequestOptions{..} = do
  fg <- forgejo
  requestedReviews (pulls fg) owner repo index $ PullReviewRequestApiOptions reviewers teamReviewers
