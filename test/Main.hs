module Main (main) where

import Forgejo.IntegrationSpec qualified as IntegrationSpec
import Forgejo.Types.EventSpec qualified as EventSpec
import Forgejo.WebhookSpec qualified as WebhookSpec
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "Forgejo.Types.Event" EventSpec.spec
  describe "Forgejo.Webhook" WebhookSpec.spec
