{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.LabelTemplateInfo
  ( LabelTemplateInfo (..)
  , LabelTemplateInfoPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data LabelTemplateInfo = LabelTemplateInfo
  { body :: Text
  , implementation :: Text
  , key :: Text
  , name :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON LabelTemplateInfo where
  parseJSON = withObject "LabelTemplateInfo" $ \o ->
    LabelTemplateInfo
      <$> o .: "body"
      <*> o .: "implementation"
      <*> o .: "key"
      <*> o .: "name"
      <*> o .: "url"

instance ToJSON LabelTemplateInfo where
  toJSON = genericToJSON runOptions

data LabelTemplateInfoPayload = LabelTemplateInfoPayload
  { arpAction :: Text
  , arpRun :: LabelTemplateInfo
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON LabelTemplateInfoPayload where
  parseJSON = withObject "LabelTemplateInfoPayload" $ \o ->
    LabelTemplateInfoPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON LabelTemplateInfoPayload where
  toJSON = genericToJSON arpOptions
