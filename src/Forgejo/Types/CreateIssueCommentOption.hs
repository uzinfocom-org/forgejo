module Forgejo.Types.CreateIssueCommentOption
  ( CreateIssueCommentOption (..)
  , CreateIssueCommentApiOption (..)
  ) where

import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

cicoOptions :: Options
cicoOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}

-- | The actual JSON body sent to Forgejo.
newtype CreateIssueCommentApiOption = CreateIssueCommentApiOption
  { cicoBody :: Text
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreateIssueCommentApiOption where
  toJSON = genericToJSON cicoOptions

{- | Wrapper carrying routing info alongside the request body,
mirroring CreateIssueOption's shape.
-}
data CreateIssueCommentOption = CreateIssueCommentOption
  { ciscoOwner :: Text
  , ciscoRepo :: Text
  , ciscoIndex :: Int
  , ciscoApiJson :: CreateIssueCommentApiOption
  }
