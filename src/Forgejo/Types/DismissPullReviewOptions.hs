{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.DismissPullReviewOptions
  ( DismissPullReviewOptions (..)
  , DismissPullReviewOptionsPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data DismissPullReviewOptions = DismissPullReviewOptions
  { message :: Text
  , priors :: Bool
  }
  deriving stock (Eq, Generic, Show)

-- Manual instance because Forgejo uses "ScheduleID" (capitalised) as the JSON key.
instance FromJSON DismissPullReviewOptions where
  parseJSON = withObject "DismissPullReviewOptions" $ \o ->
    DismissPullReviewOptions
      <$> o .: "message"
      <*> o .: "priors"

instance ToJSON DismissPullReviewOptions where
  toJSON = genericToJSON runOptions

data DismissPullReviewOptionsPayload = DismissPullReviewOptionsPayload
  { arpAction :: Text
  , arpRun :: DismissPullReviewOptions
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON DismissPullReviewOptionsPayload where
  parseJSON = withObject "DismissPullReviewOptionsPayload" $ \o ->
    DismissPullReviewOptionsPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON DismissPullReviewOptionsPayload where
  toJSON = genericToJSON arpOptions
