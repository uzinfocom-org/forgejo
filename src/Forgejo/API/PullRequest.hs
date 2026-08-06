module Forgejo.API.PullRequest
  ( PullRequestRoutes (..)
  , PullReviewRequestApiOptions (..)
  , PullReviewRequest (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.CreatePullRequestOption (CreatePullRequestOption)
import Forgejo.Types.PullRequest (PullRequest)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)
import Servant (Capture, JSON, PostCreated, ReqBody, type (:-), type (:>))

data PullRequestRoutes route = PullRequestRoutes
  { requestReviewsApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "pulls"
          :> Capture "index" Int
          :> "requested_reviewers"
          :> ReqBody '[JSON] PullReviewRequestApiOptions
          :> PostCreated '[JSON] [PullReviewRequest]
  , createPullRequestApi
      :: route
        :- "repos"
          :> Capture "owner" Text
          :> Capture "repo" Text
          :> "pulls"
          :> ReqBody '[JSON] CreatePullRequestOption
          :> PostCreated '[JSON] PullRequest
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
