module Forgejo.Methods.Contents (createFile) where

import Control.Monad (void)
import Data.ByteString.Base64 (encode)
import Data.Text (Text)
import Data.Text.Encoding (decodeUtf8, encodeUtf8)
import Forgejo.API (ForgejoRoutes (contents))
import Forgejo.API.Contents (ContentsRoutes (createFileApi), CreateFileApiOption (..))
import Forgejo.App (AppM, forgejo)
import Forgejo.Error

{- | Create a file in a branch, as one commit. The content is given as plain text
  and encoded to base64 here.

  Possible errors:

  * 'ErrForbidden': token lacks write access
  * 'ErrNotFound': owner, repository or branch does not exist
  * 'ErrConflict': file already exists
  * 'ErrValidation': invalid file path or other field error
-}
createFile
  -- | owner
  :: Text
  -- | repo
  -> Text
  -- | file path
  -> Text
  -- | branch
  -> Text
  -- | commit message
  -> Text
  -- | file content
  -> Text
  -> AppM ()
createFile owner repo path branch message content = do
  fg <- forgejo
  let opt = CreateFileApiOption (decodeUtf8 . encode $ encodeUtf8 content) message branch
  void $ createFileApi (contents fg) owner repo path opt >>= liftResult
