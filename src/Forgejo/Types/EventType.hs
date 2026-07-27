{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EventType
  ( ForgejoEventType (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), eitherDecodeStrict, encode, genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), SumEncoding (..), camelTo2, defaultOptions)
import Data.Bifunctor (first)
import Data.ByteString.Lazy qualified as BSL
import Data.Text qualified as T
import Data.Text.Encoding qualified as TE
import GHC.Generics (Generic)
import Web.HttpApiData (FromHttpApiData (..), ToHttpApiData (..))

eventTypeOptions :: Options
eventTypeOptions =
  defaultOptions
    { constructorTagModifier = camelTo2 '_'
    , sumEncoding = UntaggedValue
    }

{- | Value of the @x-forgejo-event-type@ header.
Mirrors ForgejoEvent but adds sub-event variants (e.g. PullRequestSync).
-}
data ForgejoEventType
  = -- sub-event types
    Push
  | PullRequest
  | PullRequestSync
  | PullRequestComment
  | IssueComment
  | ActionRunSuccess
  | -- action types carried in the JSON body's @action@ field
    Opened
  | Edited
  | Closed
  | Reopened
  | Deleted
  | Assigned
  | Unassigned
  | LabelUpdated
  | LabelCleared
  | Milestoned
  | Demilestoned
  | Synchronized
  | Reviewed
  | ReviewRequested
  | ReviewRequestRemoved
  | CommentDeleted
  | AutoMergeEnabled
  | AutoMergeDisabled
  deriving stock (Bounded, Enum, Eq, Generic, Ord, Show)

instance FromJSON ForgejoEventType where
  parseJSON = genericParseJSON eventTypeOptions

instance ToJSON ForgejoEventType where
  toJSON = genericToJSON eventTypeOptions

instance FromHttpApiData ForgejoEventType where
  parseHeader bs = first T.pack $ eitherDecodeStrict ("\"" <> bs <> "\"")
  parseQueryParam = parseHeader . TE.encodeUtf8

instance ToHttpApiData ForgejoEventType where
  toHeader = BSL.toStrict . BSL.tail . BSL.init . encode
  toUrlPiece = TE.decodeUtf8 . toHeader
