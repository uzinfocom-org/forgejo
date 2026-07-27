{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Event
  ( ForgejoEvent (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), eitherDecodeStrict, encode, genericParseJSON, genericToJSON)
import Data.Aeson.Types (Options (..), SumEncoding (..), camelTo2, defaultOptions)
import Data.Bifunctor (first)
import Data.ByteString.Lazy qualified as BSL
import Data.Text qualified as T
import Data.Text.Encoding qualified as TE
import GHC.Generics (Generic)
import Web.HttpApiData (FromHttpApiData (..), ToHttpApiData (..))

-- https://github.com/go-gitea/gitea/blob/main/modules/webhook/type.go

eventOptions :: Options
eventOptions =
  defaultOptions
    { constructorTagModifier = camelTo2 '_'
    , sumEncoding = UntaggedValue
    }

data ForgejoEvent
  = Create
  | Delete
  | Fork
  | Push
  | Issues
  | IssueComment
  | PullRequest
  | PullRequestApproved
  | PullRequestRejected
  | PullRequestComment
  | Repository
  | Release
  | Package
  | ActionRunSuccess
  deriving stock (Bounded, Enum, Eq, Generic, Ord, Show)

instance FromJSON ForgejoEvent where
  parseJSON = genericParseJSON eventOptions

instance ToJSON ForgejoEvent where
  toJSON = genericToJSON eventOptions

instance FromHttpApiData ForgejoEvent where
  parseHeader bs = first T.pack $ eitherDecodeStrict ("\"" <> bs <> "\"")
  parseQueryParam = parseHeader . TE.encodeUtf8

instance ToHttpApiData ForgejoEvent where
  toHeader = BSL.toStrict . BSL.tail . BSL.init . encode
  toUrlPiece = TE.decodeUtf8 . toHeader
