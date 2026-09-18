-- Integration tests against a live Forgejo instance.
-- Required environment variables:
--   FORGEJO_URL   – base URL, e.g. https://codeberg.org
--   FORGEJO_TOKEN – personal access token with write:repository and write:issue scopes
--   FORGEJO_OWNER – username/org that owns the test repository
--   FORGEJO_REPO  – name of a pre-existing repository (used for issue tests)
-- Optional:
--   FORGEJO_ORG   – organisation name; enables Organisation tests when set
--
-- When required variables are absent all tests are marked pending so the
-- suite still passes in environments without a live instance.
module Forgejo.IntegrationSpec (spec) where

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
  pure $ mkAppEnv (mkClientEnv manager baseUrl) (T.pack token)

spec :: Spec
spec = do
  mUrl <- runIO $ lookupEnv "FORGEJO_URL"
  mToken <- runIO $ lookupEnv "FORGEJO_TOKEN"
  mOwner <- runIO $ lookupEnv "FORGEJO_OWNER"
  mRepo <- runIO $ lookupEnv "FORGEJO_REPO"
  mOrg <- runIO $ lookupEnv "FORGEJO_ORG"

  case (mUrl, mToken, mOwner, mRepo) of
    (Just url, Just token, Just owner, Just repo) ->
      beforeAll (mkTestEnv url token) $ do
        describe "Repository" Repository.spec
        describe "Issue" (Issue.spec (T.pack owner) (T.pack repo))
        describe "Organization" (Organization.spec (T.pack <$> mOrg))
    _ ->
      it "integration tests (set FORGEJO_URL, FORGEJO_TOKEN, FORGEJO_OWNER, FORGEJO_REPO to enable)"
        $ pending
