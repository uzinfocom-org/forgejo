{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateEmailOption
  ( CreateEmailOption (..)
  , CreateEmailOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data CreateEmailOption = CreateEmailOption
  { emails :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON CreateEmailOption where
  parseJSON = withObject "CreateEmailOption" $ \o ->
    CreateEmailOption
      <$> o .: "emails"

instance ToJSON CreateEmailOption where
  toJSON = genericToJSON runOptions

data CreateEmailOptionPayload = CreateEmailOptionPayload
  { arpAction :: Text
  , arpRun :: CreateEmailOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateEmailOptionPayload where
  parseJSON = withObject "CreateEmailOptionPayload" $ \o ->
    CreateEmailOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateEmailOptionPayload where
  toJSON = genericToJSON arpOptions
