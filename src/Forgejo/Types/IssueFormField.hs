{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.IssueFormField
  ( IssueFormField (..)
  , IssueFormFieldPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data IssueFormField = IssueFormField
  { attributes :: Text
  , id :: Text
  , iffType :: Text -- "markdown", "textarea", "input", "dropdown" or "checkboxes"
  , validations :: Text
  , visible :: [Text]
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON IssueFormField where
  parseJSON = withObject "IssueFormField" $ \o ->
    IssueFormField
      <$> o .: "attributes"
      <*> o .: "id"
      <*> o .: "type"
      <*> o .: "validations"
      <*> o .: "visible"

instance ToJSON IssueFormField where
  toJSON = genericToJSON runOptions

data IssueFormFieldPayload = IssueFormFieldPayload
  { arpAction :: Text
  , arpRun :: IssueFormField
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON IssueFormFieldPayload where
  parseJSON = withObject "IssueFormFieldPayload" $ \o ->
    IssueFormFieldPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON IssueFormFieldPayload where
  toJSON = genericToJSON arpOptions
