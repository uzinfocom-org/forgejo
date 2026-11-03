{-# LANGUAGE OverloadedStrings #-}

module Forgejo.Types.ContentTypes (JSONOrEmpty) where

import Data.Aeson (FromJSON, eitherDecode)
import Data.List.NonEmpty (NonEmpty (..))
import Network.HTTP.Media ((//))
import Servant (NoContent (..))
import Servant.API.ContentTypes (Accept (..), MimeUnrender (..))

{- | JSON for normal bodies, plus the @application/octet-stream@ fallback
servant-client uses when a 204 comes back without a @Content-Type@ header.
Use it as the content type list of any 'UVerb' with an empty 'NoContent' alternative.
-}
data JSONOrEmpty

instance Accept JSONOrEmpty where
  contentTypes _ = ("application" // "json") :| ["application" // "octet-stream"]

instance {-# OVERLAPPABLE #-} (FromJSON a) => MimeUnrender JSONOrEmpty a where
  mimeUnrender _ = eitherDecode

instance MimeUnrender JSONOrEmpty NoContent where
  mimeUnrender _ _ = Right NoContent
