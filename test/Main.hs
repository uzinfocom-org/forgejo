module Main (main) where

import Forgejo ()
import Test.Hspec

main :: IO ()
main =
  hspec
    $ describe "forgejo"
    $ it "links the library"
    $ True `shouldBe` True
