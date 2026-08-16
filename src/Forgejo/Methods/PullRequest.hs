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
import Forgejo.Error
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

{- | Create a pull request.

  Possible errors:

  * 'ErrForbidden': token lacks write access
  * 'ErrNotFound': owner or repository does not exist
  * 'ErrConflict': pull request for this branch already exists
  * 'ErrValidation': invalid base\/head branch or other field error
-}
createPullRequest :: Text -> Text -> CreatePullRequestOption -> AppM PullRequest
createPullRequest owner repo opts = do
  fg <- forgejo
  createPullRequestApi (pulls fg) owner repo opts >>= liftResult

{- | Request reviewers on a pull request.

  Possible errors:

  * 'ErrValidation': reviewer usernames are invalid or not collaborators
-}
addReviewer :: PullReviewRequestOptions -> AppM [PullReviewRequest]
addReviewer PullReviewRequestOptions{..} = do
  fg <- forgejo
  requestReviewsApi (pulls fg) owner repo index (PullReviewRequestApiOptions reviewers teamReviewers) >>= liftResult
