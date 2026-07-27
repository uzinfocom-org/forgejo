module Forgejo.App where

import Control.Monad.Except (MonadError, throwError)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Reader (MonadReader, ReaderT (..), asks, runReaderT)
import Data.Text (Text)
import Forgejo.API (ForgejoAPI, ForgejoRoutes)
import Forgejo.API qualified as FA
import Servant (Handler, ServerError, err500, errBody)
import Servant.Client (AsClientT, ClientEnv, ClientM, runClientM)
import Servant.Client.Generic (genericClientHoist)
import System.IO (hPutStrLn, stderr)

data AppEnv = AppEnv
  { envForgejo :: ForgejoRoutes (AsClientT AppM)
  , envClientEnv :: ClientEnv
  }

newtype AppM a = AppM {unAppM :: ReaderT AppEnv Handler a}
  deriving newtype (Applicative, Functor, Monad, MonadError ServerError, MonadIO, MonadReader AppEnv)

runAppM :: AppEnv -> AppM a -> Handler a
runAppM env = flip runReaderT env . unAppM

clientMToAppM :: ClientM a -> AppM a
clientMToAppM action = do
  cenv <- asks envClientEnv
  liftIO (runClientM action cenv) >>= either handleError pure
 where
  handleError err = do
    liftIO $ hPutStrLn stderr $ "Forgejo API error: " <> show err
    throwError err500{errBody = mempty} -- FIXME: Better error handling

forgejo :: AppM (ForgejoRoutes (AsClientT AppM))
forgejo = asks envForgejo

mkAppEnv :: ClientEnv -> Text -> AppEnv
mkAppEnv cenv token =
  AppEnv
    { envForgejo = FA.v1 (genericClientHoist clientMToAppM :: ForgejoAPI (AsClientT AppM)) token
    , envClientEnv = cenv
    }
