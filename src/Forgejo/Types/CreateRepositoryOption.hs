{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.CreateRepositoryOption
  ( CreateRepositoryOption (..)
  , CreateOrgRepositoryOption (..)
  ) where

import Data.Aeson (ToJSON (..), genericToJSON)
import Data.Aeson.Types (Options (..), camelTo2, defaultOptions)
import Data.Text (Text)
import GHC.Generics (Generic)

data CreateRepositoryOption = CreateRepositoryOption
  { croDescription :: Text
  , croName :: Text
  , croPrivate :: Bool
  }
  deriving stock (Eq, Generic, Show)

data CreateOrgRepositoryOption = CreateOrgRepositoryOption
  { coroOwner :: Text
  , coroApiJson :: CreateRepositoryOption
  }
  deriving stock (Eq, Generic, Show)

instance ToJSON CreateRepositoryOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 3}

instance ToJSON CreateOrgRepositoryOption where
  toJSON = genericToJSON defaultOptions{fieldLabelModifier = camelTo2 '_' . drop 4}
