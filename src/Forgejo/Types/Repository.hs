module Forgejo.Types.Repository
  ( InternalTracker (..)
  , RepoPermissions (..)
  , Repository (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), Value, genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.Common (RepoId)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

repoOptions :: Options
repoOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}

permOptions :: Options
permOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}

trackerOptions :: Options
trackerOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 7}

data RepoPermissions = RepoPermissions
  { permAdmin :: Bool
  , permPush :: Bool
  , permPull :: Bool
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON RepoPermissions where
  parseJSON = genericParseJSON permOptions

instance ToJSON RepoPermissions where
  toJSON = genericToJSON permOptions

data InternalTracker = InternalTracker
  { trackerEnableTimeTracker :: Bool
  , trackerAllowOnlyContributorsToTrackTime :: Bool
  , trackerEnableIssueDependencies :: Bool
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON InternalTracker where
  parseJSON = genericParseJSON trackerOptions

instance ToJSON InternalTracker where
  toJSON = genericToJSON trackerOptions

data Repository = Repository
  { repoId :: RepoId
  , repoOwner :: User
  , repoName :: Text
  , repoFullName :: Text
  , repoDescription :: Text
  , repoEmpty :: Bool
  , repoPrivate :: Bool
  , repoFork :: Bool
  , repoTemplate :: Bool
  , repoParent :: Maybe Repository
  , repoMirror :: Bool
  , repoSize :: Int
  , repoLanguage :: Text
  , repoLanguagesUrl :: Text
  , repoHtmlUrl :: Text
  , repoUrl :: Text
  , repoLink :: Text
  , repoSshUrl :: Text
  , repoCloneUrl :: Text
  , repoOriginalUrl :: Text
  , repoWebsite :: Text
  , repoStarsCount :: Int
  , repoForksCount :: Int
  , repoWatchersCount :: Int
  , repoOpenIssuesCount :: Int
  , repoOpenPrCounter :: Int
  , repoReleaseCounter :: Int
  , repoDefaultBranch :: Text
  , repoArchived :: Bool
  , repoCreatedAt :: UTCTime
  , repoUpdatedAt :: UTCTime
  , repoArchivedAt :: UTCTime
  , repoPermissions :: RepoPermissions
  , repoHasIssues :: Bool
  , repoInternalTracker :: InternalTracker
  , repoHasWiki :: Bool
  , repoHasWikiContents :: Bool
  , repoWikiBranch :: Text
  , repoWikiSshUrl :: Text
  , repoWikiCloneUrl :: Text
  , repoGloballyEditableWiki :: Bool
  , repoHasPullRequests :: Bool
  , repoHasProjects :: Bool
  , repoHasReleases :: Bool
  , repoHasPackages :: Bool
  , repoHasActions :: Bool
  , repoIgnoreWhitespaceConflicts :: Bool
  , repoAllowMergeCommits :: Bool
  , repoAllowRebase :: Bool
  , repoAllowRebaseExplicit :: Bool
  , repoAllowSquashMerge :: Bool
  , repoAllowFastForwardOnlyMerge :: Bool
  , repoAllowRebaseUpdate :: Bool
  , repoDefaultDeleteBranchAfterMerge :: Bool
  , repoDefaultMergeStyle :: Text
  , repoDefaultAllowMaintainerEdit :: Bool
  , repoDefaultUpdateStyle :: Text
  , repoAvatarUrl :: Text
  , repoInternal :: Bool
  , repoMirrorInterval :: Text
  , repoObjectFormatName :: Text
  , repoMirrorUpdated :: UTCTime
  , repoRepoTransfer :: Maybe Value
  , repoTopics :: [Text]
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON Repository where
  parseJSON = genericParseJSON repoOptions

instance ToJSON Repository where
  toJSON = genericToJSON repoOptions
