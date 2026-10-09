{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Methods.PullRequest (PullReviewRequestOptions (..), addReviewer, createPullRequest, getPullRequestFiles, getPullRequestCommits)
where

import Control.Monad (mfilter)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (pulls))
import Forgejo.API.PullRequest
  ( PullRequestRoutes (..)
  , PullReviewRequest
  , PullReviewRequestApiOptions (..)
  )
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.ChangedFile (ChangedFile (..))
import Forgejo.Types.CreatePullRequestOption (CreatePullRequestOption)
import Forgejo.Types.PullRequest (PullRequest)
import Forgejo.Types.PullRequestCommit (PullRequestCommit (..))
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

{- | Get all changed files of a pull request.

  It reads every page of the list, so a big pull request costs more than one request.
  The page size is optional, 'Nothing' means 'defaultPageSize'.

  Possible errors:

  * 'ErrNotFound': owner, repository or pull request does not exist
-}
getPullRequestFiles :: Text -> Text -> Int -> Maybe Int -> AppM [ChangedFile]
getPullRequestFiles owner repo index size = do
  fg <- forgejo
  fetchAllPages (pageSizeOf size) \page limit ->
    fromMaybe []
      <$> ( listPullRequestFilesApi (pulls fg) owner repo index Nothing Nothing (Just page) (Just limit)
              >>= liftResult
          )

{- | Get all commits of a pull request, newest first.

  It reads every page of the list. Verification and affected files of each commit are
  switched off, because they are slow and we don't use them.
  The page size is optional, 'Nothing' means 'defaultPageSize'.

  Possible errors:

  * 'ErrNotFound': owner, repository or pull request does not exist
  * 'ErrConflict': Forgejo can't compare the branches of the pull request
-}
getPullRequestCommits :: Text -> Text -> Int -> Maybe Int -> AppM [PullRequestCommit]
getPullRequestCommits owner repo index size = do
  fg <- forgejo
  fetchAllPages (pageSizeOf size) \page limit ->
    listPullRequestCommitsApi (pulls fg) owner repo index (Just page) (Just limit) (Just False) (Just False)
      >>= liftResult


-- FIXME: Pagination helpers below (defaultPageSize, pageSizeOf, fetchAllPages) are generic and
-- have nothing to do with pull requests. Need to move them into separate module (e.g. `Forgejo.Pagination`)
-- as soon as other methods (issues, repositories, releases) start to read lists.

-- | Page size used when the caller gives none. It is the default page size of Forgejo.
defaultPageSize :: Int
defaultPageSize = 30

-- | A given size counts only when it is positive, otherwise 'defaultPageSize' is used.
pageSizeOf :: Maybe Int -> Int
pageSizeOf = fromMaybe defaultPageSize . mfilter (> 0)

{- | Fetch every page of a list, stop at the first page which is shorter than the page size.

  The size must not be bigger than the limit of server (50 by default), otherwise
  a full page of server looks short and rest of the pages are skipped.

  TODO: stop on empty page instead, so that a big size can't skip data. It costs one more request per list. Also, we need to implement parameter like Settings for general usage.
-}
fetchAllPages :: (Monad m) => Int -> (Int -> Int -> m [a]) -> m [a]
fetchAllPages size fetch = go 1
  where
  go page = do
    items <- fetch page size
    if length items < size then
      pure items
    else
      (items <>) <$> go (page + 1)
