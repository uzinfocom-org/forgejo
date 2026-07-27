module Forgejo.Types.Push
  ( PushPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.Commit (Commit)
import Forgejo.Types.Repository (Repository)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

pushOptions :: Options
pushOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}

data PushPayload = PushPayload
  { pushRef :: Text
  , pushBefore :: Text
  , pushAfter :: Text
  , pushCompareUrl :: Text
  , pushCommits :: [Commit]
  , pushTotalCommits :: Int
  , pushHeadCommit :: Commit
  , pushRepository :: Repository
  , pushPusher :: User
  , pushSender :: User
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON PushPayload where
  parseJSON = genericParseJSON pushOptions

instance ToJSON PushPayload where
  toJSON = genericToJSON pushOptions
