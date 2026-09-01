module Forgejo.Types.EventSpec (spec) where

import Data.Aeson (decode, encode)
import Forgejo.Types.Event (ForgejoEvent (..))
import Test.Hspec
import Web.HttpApiData (parseHeader, toHeader)

spec :: Spec
spec = do
  describe "JSON encoding" $ do
    it "encodes Push as \"push\""
      $ encode Push `shouldBe` "\"push\""
    it "encodes IssueComment as \"issue_comment\""
      $ encode IssueComment `shouldBe` "\"issue_comment\""
    it "encodes PullRequestApproved as \"pull_request_approved\""
      $ encode PullRequestApproved `shouldBe` "\"pull_request_approved\""
    it "encodes ActionRunSuccess as \"action_run_success\""
      $ encode ActionRunSuccess `shouldBe` "\"action_run_success\""

  describe "JSON decoding" $ do
    it "decodes \"push\""
      $ (decode "\"push\"" :: Maybe ForgejoEvent) `shouldBe` Just Push
    it "decodes \"pull_request\""
      $ (decode "\"pull_request\"" :: Maybe ForgejoEvent) `shouldBe` Just PullRequest
    it "decodes \"issue_comment\""
      $ (decode "\"issue_comment\"" :: Maybe ForgejoEvent) `shouldBe` Just IssueComment
    it "returns Nothing for unknown event names"
      $ (decode "\"bogus_event\"" :: Maybe ForgejoEvent) `shouldBe` Nothing

  describe "JSON roundtrip"
    $ it "roundtrips all constructors"
    $ mapM_ (\e -> decode (encode e) `shouldBe` Just e) [minBound .. maxBound @ForgejoEvent]

  describe "HTTP header encoding"
    $ it "roundtrips all constructors through header encoding"
    $ mapM_ (\e -> parseHeader (toHeader e) `shouldBe` Right e) [minBound .. maxBound @ForgejoEvent]
