module Forgejo.API.PullRequest
  ( PullRequestRoutes (..)
  , PullReviewRequestApiOptions (..)
  , PullReviewRequest (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)
import Servant (Capture, JSON, Post, ReqBody, type (:-), type (:>))

data PullRequestRoutes route = PullRequestRoutes
  { requestedReviews
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "pulls"
          :> Capture "index" Int
          :> "requested_reviewers"
          :> ReqBody '[JSON] PullReviewRequestApiOptions
          :> Post '[JSON] [PullReviewRequest]
  }
  deriving stock (Generic)

data PullReviewRequestApiOptions = PullReviewRequestApiOptions
  { reviewers :: [Text]
  , teamReviewers :: [Text]
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON PullReviewRequestApiOptions where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_'}

newtype PullReviewRequest = PullReviewRequest
  { pullReviewRequestUser :: Maybe User
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PullReviewRequest where
  parseJSON = genericParseJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 17}
