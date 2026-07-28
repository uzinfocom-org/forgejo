{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.EditHookOption
  ( EditHookOption (..)
  , EditHookOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data EditHookOption = EditHookOption
  { active :: Bool
  , authorizationHeader :: Text
  , branchFilter :: Text
  , config :: [Text] -- FIXME: example: {<*> :: Text}
  , events :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON EditHookOption where
  parseJSON = withObject "EditHookOption" $ \o ->
    EditHookOption
      <$> o .: "active"
      <*> o .: "authorization_header"
      <*> o .: "branch_filter"
      <*> o .: "config"
      <*> o .: "events"

instance ToJSON EditHookOption where
  toJSON = genericToJSON runOptions

data EditHookOptionPayload = EditHookOptionPayload
  { arpAction :: Text
  , arpRun :: EditHookOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON EditHookOptionPayload where
  parseJSON = withObject "EditHookOptionPayload" $ \o ->
    EditHookOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON EditHookOptionPayload where
  toJSON = genericToJSON arpOptions
