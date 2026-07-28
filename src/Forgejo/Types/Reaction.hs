{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.Reaction
  ( Reaction (..)
  , ReactionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import Forgejo.Types.User (User)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data Reaction = Reaction
  { content :: Text
  , createdAt :: UTCTime
  , user :: User
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON Reaction where
  parseJSON = withObject "Reaction" $ \o ->
    Reaction
      <$> o .: "content"
      <*> o .: "created_at"
      <*> o .: "user"

instance ToJSON Reaction where
  toJSON = genericToJSON runOptions

data ReactionPayload = ReactionPayload
  { arpAction :: Text
  , arpRun :: Reaction
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON ReactionPayload where
  parseJSON = withObject "ReactionPayload" $ \o ->
    ReactionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON ReactionPayload where
  toJSON = genericToJSON arpOptions
