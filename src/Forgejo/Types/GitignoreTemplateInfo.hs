{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.GitignoreTemplateInfo
  ( GitignoreTemplateInfo (..)
  , GitignoreTemplateInfoPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data GitignoreTemplateInfo = GitignoreTemplateInfo
  { name :: Text
  , source :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON GitignoreTemplateInfo where
  parseJSON = withObject "GitignoreTemplateInfo" $ \o ->
    GitignoreTemplateInfo
      <$> o .: "name"
      <*> o .: "source"

instance ToJSON GitignoreTemplateInfo where
  toJSON = genericToJSON runOptions

data GitignoreTemplateInfoPayload = GitignoreTemplateInfoPayload
  { arpAction :: Text
  , arpRun :: GitignoreTemplateInfo
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON GitignoreTemplateInfoPayload where
  parseJSON = withObject "GitignoreTemplateInfoPayload" $ \o ->
    GitignoreTemplateInfoPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON GitignoreTemplateInfoPayload where
  toJSON = genericToJSON arpOptions
