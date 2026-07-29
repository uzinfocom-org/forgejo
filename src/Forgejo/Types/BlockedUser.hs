{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.BlockedUser
  ( BlockedUser (..)
  , BlockedUserPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import Data.Time (UTCTime)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data BlockedUser = BlockedUser
  { blockId :: Int
  , createdAt :: UTCTime
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON BlockedUser where
  parseJSON = withObject "BlockedUser" $ \o ->
    BlockedUser
      <$> o .: "block_id"
      <*> o .: "created_at"

instance ToJSON BlockedUser where
  toJSON = genericToJSON runOptions

data BlockedUserPayload = BlockedUserPayload
  { arpAction :: Text
  , arpRun :: BlockedUser
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON BlockedUserPayload where
  parseJSON = withObject "BlockedUserPayload" $ \o ->
    BlockedUserPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON BlockedUserPayload where
  toJSON = genericToJSON arpOptions
