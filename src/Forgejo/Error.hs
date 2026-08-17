module Forgejo.Error
  ( ForgejoError (..)
  , AsForgejoError (..)
  , liftResult
  ) where

import Control.Monad.Except (MonadError, throwError)
import Data.SOP (All, I (..), NS (..))
import Data.Text (Text)
import Forgejo.Types.APIError (APIError (..))
import Forgejo.Types.APIForbiddenError (APIForbiddenError (..))
import Forgejo.Types.APIInternalServerError (APIInternalServerError (..))
import Forgejo.Types.APIInvalidTopicsError (APIInvalidTopicsError (..))
import Forgejo.Types.APINotFound (APINotFound (..))
import Forgejo.Types.APIRepoArchivedError (APIRepoArchivedError (..))
import Forgejo.Types.APIUnauthorizedError (APIUnauthorizedError (..))
import Forgejo.Types.APIValidationError (APIValidationError (..))
import GHC.Generics (Generic)
import Network.HTTP.Types (status400)
import Servant (Union, WithStatus (..))
import Servant.API.Status (KnownStatus (statusVal))

data ForgejoError
  = ErrBadRequest Text Text
  | ErrUnauthorized Text Text
  | ErrForbidden Text Text
  | ErrNotFound Text Text [Text]
  | ErrConflict Text Text
  | ErrValidation Text Text
  | ErrInvalidTopics [Text] Text
  | ErrRepoArchived Text Text
  | ErrServer Text Text
  | ErrDecodeFailure Text
  | ErrNetwork Text
  | ErrUnexpected Int Text
  deriving stock (Eq, Generic, Show)

class AsForgejoError a where
  asForgejoError :: a -> ForgejoError

instance AsForgejoError (WithStatus 400 APIError) where
  asForgejoError (WithStatus e) = ErrBadRequest e.message e.url

instance AsForgejoError (WithStatus 401 APIUnauthorizedError) where
  asForgejoError (WithStatus e) = ErrUnauthorized e.message e.url

instance AsForgejoError (WithStatus 403 APIForbiddenError) where
  asForgejoError (WithStatus e) = ErrForbidden e.message e.url

instance AsForgejoError (WithStatus 404 APINotFound) where
  asForgejoError (WithStatus e) = ErrNotFound e.message e.url e.errors

instance AsForgejoError (WithStatus 409 APIError) where
  asForgejoError (WithStatus e) = ErrConflict e.message e.url

instance AsForgejoError (WithStatus 422 APIValidationError) where
  asForgejoError (WithStatus e) = ErrValidation e.message e.url

instance AsForgejoError (WithStatus 422 APIInvalidTopicsError) where
  asForgejoError (WithStatus e) = ErrInvalidTopics e.invalidTopics e.url

instance AsForgejoError (WithStatus 423 APIRepoArchivedError) where
  asForgejoError (WithStatus e) = ErrRepoArchived e.message e.url

instance AsForgejoError (WithStatus 500 APIInternalServerError) where
  asForgejoError (WithStatus e) = ErrServer e.message e.url

liftResult
  :: (All AsForgejoError errs, MonadError ForgejoError m)
  => Union (WithStatus n a ': errs)
  -> m a
liftResult (Z (I (WithStatus a))) = pure a
liftResult (S es) = throwError (collapseErrors es)

collapseErrors :: (All AsForgejoError xs) => NS I xs -> ForgejoError
collapseErrors (Z (I e)) = asForgejoError e
collapseErrors (S xs) = collapseErrors xs
