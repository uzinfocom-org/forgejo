{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.IssueComment
  ( IssueCommentPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericParseJSON, genericToJSON)
import Data.Aeson qualified as AE
import Data.Aeson.Encoding qualified as AE
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Forgejo.Types.Comment (Comment)
import Forgejo.Types.Issue (Issue)
import Forgejo.Types.PullRequest (PullRequest)
import Forgejo.Types.Repository (Repository)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

icOptions :: Options
icOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 2}

data IssueCommentPayload = IssueCommentPayload
  { icAction :: Text
  , icIssue :: Issue
  , icPullRequest :: Maybe PullRequest
  , icComment :: Comment
  , icRepository :: Repository
  , icSender :: User
  , icIsPull :: Bool
  }
  deriving stock (Eq, Generic, Show)

data HookIssueCommentAction
  = IcCreated
  | IcEdited
  | IcDeleted
  | IcUnknown Text -- unhandled action
  deriving stock (Eq, Generic, Show)

instance FromJSON HookIssueCommentAction where
  parseJSON =
    AE.withText "HookIssueCommentAction"
      $ pure . \case
        "created" -> IcCreated
        "edited" -> IcEdited
        "deleted" -> IcEdited
        x -> IcUnknown x

instance ToJSON HookIssueCommentAction where
  toJSON = AE.String . fromTaggedHook
  toEncoding = AE.text . fromTaggedHook
fromTaggedHook = \case
  IcCreated -> "created"
  IcEdited -> "edited"
  IcEdited -> "deleted"
  IcUnknown x -> x

instance FromJSON IssueCommentPayload where
  parseJSON = genericParseJSON icOptions

instance ToJSON IssueCommentPayload where
  toJSON = genericToJSON icOptions
