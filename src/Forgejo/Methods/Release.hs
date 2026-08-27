module Forgejo.Methods.Release
  ( createRelease
  ) where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (releases))
import Forgejo.API.Release (ReleaseRoutes (createReleaseApi))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error
import Forgejo.Types.CreateReleaseOption (CreateReleaseOption (..))
import Forgejo.Types.Release (Release)

{- | Create a Release for the authenticated user.

  Possible errors:

  * 'ErrBadRequest': malformed request body
  * 'ErrNotFound': authenticated user not found
  * 'ErrValidation': invalid Release name or settings
-}
createRelease :: Text -> Text -> CreateReleaseOption -> AppM Release
createRelease owner repo c = do
  fg <- forgejo
  createReleaseApi (releases fg) owner repo c >>= liftResult
