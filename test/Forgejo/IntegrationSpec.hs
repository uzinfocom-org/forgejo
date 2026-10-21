module Forgejo.IntegrationSpec (spec) where

import Control.Monad (mfilter)
import Data.Text qualified as T
import Forgejo (AppEnv, mkAppEnv)
import Forgejo.Integration.Issue qualified as Issue
import Forgejo.Integration.Organization qualified as Organization
import Forgejo.Integration.Repository qualified as Repository
import Network.HTTP.Client.TLS (newTlsManager)
import Servant.Client (mkClientEnv, parseBaseUrl)
import System.Environment (lookupEnv)
import Test.Hspec

mkTestEnv :: String -> String -> IO AppEnv
mkTestEnv url token = do
  manager <- newTlsManager
  baseUrl <- parseBaseUrl url
  pure $ mkAppEnv (mkClientEnv manager baseUrl) ("token " <> T.pack token)

spec :: Spec
spec = do
  mUrl <- runIO $ lookupEnv "FORGEJO_URL"
  mToken <- runIO $ lookupEnv "FORGEJO_TOKEN"
  mOrg <- runIO $ mfilter (not . null) <$> lookupEnv "FORGEJO_ORG"

  case (mUrl, mToken) of
    (Just url, Just token) ->
      beforeAll (mkTestEnv url token) $ do
        describe "Repository" Repository.spec
        describe "Issue" Issue.spec
        describe "Organization" (Organization.spec (T.pack <$> mOrg))
    _ ->
      it "integration tests (set FORGEJO_URL and FORGEJO_TOKEN to enable)" pending
