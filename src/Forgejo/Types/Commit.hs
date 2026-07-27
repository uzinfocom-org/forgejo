module Forgejo.Types.Commit
  ( Commit (..)
  , CommitAuthor (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value, genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

commitOptions :: Options
commitOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 6}

authorOptions :: Options
authorOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 6}

data CommitAuthor = CommitAuthor
  { authorName :: Text
  , authorEmail :: Text
  , authorUsername :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CommitAuthor where
  parseJSON = genericParseJSON authorOptions

instance ToJSON CommitAuthor where
  toJSON = genericToJSON authorOptions

data Commit = Commit
  { commitId :: Text
  , commitMessage :: Text
  , commitUrl :: Text
  , commitAuthor :: CommitAuthor
  , commitCommitter :: CommitAuthor
  , commitVerification :: Maybe Value
  , commitTimestamp :: UTCTime
  , commitAdded :: [Text]
  , commitRemoved :: [Text]
  , commitModified :: [Text]
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Commit where
  parseJSON = genericParseJSON commitOptions

instance ToJSON Commit where
  toJSON = genericToJSON commitOptions
