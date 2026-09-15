module Forgejo.Methods.Release where

import Data.Text (Text)
import Forgejo.API (ForgejoRoutes (releases))
import Forgejo.API.Release (ReleaseRoutes (editReleaseApi))
import Forgejo.App (AppM, forgejo)
import Forgejo.Types.Common (ReleaseId (..))
import Forgejo.Error
import Forgejo.Types.EditReleaseOption (EditReleaseOption)
import Forgejo.Types.Release (Release)

{- | Edit existing release.

  Possible errors:

  * 'ErrNotFound': release not found
-}
editRelease :: Text -> Text -> ReleaseId -> EditReleaseOption -> AppM Release
editRelease owner repo relId opts = do
  fg <- forgejo
  editReleaseApi (releases fg) owner repo relId opts >>= liftResult
