{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateHookOption
  ( CreateHookOption (..)
  , CreateHookOptionPayload (..)
  ) where

import Data.Aeson (FromJSON (..), ToJSON (..), genericToJSON, withObject, (.:))
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

arpOptions :: Options
arpOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

runOptions :: Options
runOptions = defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

data HType
  = HForgejo
  | Dingtalk
  | Discord
  | Gitea
  | Gogs
  | Msteams
  | Slack
  | Telegram
  | Feishu
  | Wechatwork
  | Packagist
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data CreateHookOptionConfig = CreateHookOptionConfig
  { contentType :: Text
  , url :: Text
  }
  deriving stock (Eq, Generic, Show)
  deriving anyclass (FromJSON, ToJSON)

data CreateHookOption = CreateHookOption
  { active :: Bool
  , authorizationHeader :: Text
  , branchFilter :: Text
  , config :: CreateHookOptionConfig
  , events :: [Text]
  , cType :: HType
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateHookOption where
  parseJSON = withObject "CreateHookOption" $ \o ->
    CreateHookOption
      <$> o .: "active"
      <*> o .: "authorization_header"
      <*> o .: "branch_filter"
      <*> o .: "config"
      <*> o .: "events"
      <*> o .: "type"

instance ToJSON CreateHookOption where
  toJSON = genericToJSON runOptions

data CreateHookOptionPayload = CreateHookOptionPayload
  { arpAction :: Text
  , arpRun :: CreateHookOption
  , arpPriorStatus :: Text
  }
  deriving stock (Eq, Generic, Show)

instance FromJSON CreateHookOptionPayload where
  parseJSON = withObject "CreateHookOptionPayload" $ \o ->
    CreateHookOptionPayload
      <$> o .: "action"
      <*> o .: "run"
      <*> o .: "prior_status"

instance ToJSON CreateHookOptionPayload where
  toJSON = genericToJSON arpOptions
