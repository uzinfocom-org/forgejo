{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Forgejo.App
  ( AppEnv
  , AppM
  , mkAppEnv
  , runAppM
  , runForgejo
  , forgejo
  ) where

import Control.Monad.Except (ExceptT, MonadError, runExceptT, throwError)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Reader (MonadReader, ReaderT (..), asks, runReaderT)
import Data.ByteString.Lazy qualified as BSL
import Data.Text (Text, pack)
import Data.Text.Encoding (decodeUtf8Lenient, encodeUtf8)
import Forgejo.API (ForgejoAPI, ForgejoRoutes)
import Forgejo.API qualified as FA
import Forgejo.Error (ForgejoError (..))
import Network.HTTP.Types.Status
import Servant (Handler, ServerError (..), err400, err401, err403, err404, err409, err422, err500, err503)
import Servant.API.Status
import Servant.Client (AsClientT, ClientEnv, ClientError (..), ClientM, runClientM)
import Servant.Client.Core (responseBody, responseStatusCode)
import Servant.Client.Generic (genericClientHoist)

data AppEnv = AppEnv
  { envForgejo :: ForgejoRoutes (AsClientT AppM)
  , envClientEnv :: ClientEnv
  }

newtype AppM a = AppM {unAppM :: ReaderT AppEnv (ExceptT ForgejoError IO) a}
  deriving newtype (Applicative, Functor, Monad, MonadError ForgejoError, MonadIO, MonadReader AppEnv)

runAppM :: AppEnv -> AppM a -> Handler a
runAppM env action = do
  result <- liftIO $ runExceptT (runReaderT (unAppM action) env)
  either (throwError . toServantError) pure result

runForgejo :: AppEnv -> AppM a -> IO (Either ForgejoError a)
runForgejo env = runExceptT . flip runReaderT env . unAppM

forgejo :: AppM (ForgejoRoutes (AsClientT AppM))
forgejo = asks envForgejo

mkAppEnv :: ClientEnv -> Text -> AppEnv
mkAppEnv cenv token =
  AppEnv
    { envForgejo = FA.v1 (genericClientHoist clientMToAppM :: ForgejoAPI (AsClientT AppM)) token
    , envClientEnv = cenv
    }

clientMToAppM :: ClientM a -> AppM a
clientMToAppM action = do
  cenv <- asks envClientEnv
  liftIO (runClientM action cenv) >>= either (throwError . fromClientError) pure

fromClientError :: ClientError -> ForgejoError
fromClientError = \case
  FailureResponse _ resp ->
    ErrUnexpected
      (statusCode (responseStatusCode resp))
      (decodeUtf8Lenient $ BSL.toStrict (responseBody resp))
  DecodeFailure msg _ -> ErrDecodeFailure msg
  ConnectionError ex -> ErrNetwork (pack $ show ex)
  _ -> ErrDecodeFailure (pack "unexpected servant-client error")

toServantError :: ForgejoError -> ServerError
toServantError = \case
  ErrBadRequest msg _ -> err400{errBody = body msg}
  ErrUnauthorized msg _ -> err401{errBody = body msg}
  ErrForbidden msg _ -> err403{errBody = body msg}
  ErrNotFound msg _ _ -> err404{errBody = body msg}
  ErrConflict msg _ -> err409{errBody = body msg}
  ErrValidation msg _ -> err422{errBody = body msg}
  ErrInvalidTopics _ u -> err422{errBody = body u}
  ErrRepoArchived msg _ -> err423{errBody = body msg}
  ErrServer msg _ -> err500{errBody = body msg}
  ErrDecodeFailure msg -> err500{errBody = body msg}
  ErrNetwork msg -> err503{errBody = body msg}
  ErrUnexpected code msg -> ServerError code "Unexpected Error" (body msg) []
 where
  body = BSL.fromStrict . encodeUtf8

err423 :: ServerError
err423 =
  ServerError
    { errHTTPCode = 423
    , errReasonPhrase = "Arhived"
    , errBody = mempty
    , errHeaders = []
    }

instance KnownStatus 423 where
  statusVal _ = mkStatus 423 "Archived"
