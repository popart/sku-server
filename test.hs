{-# LANGUAGE OverloadedStrings #-}
import Shoe
import Data.Aeson
import Data.Maybe

test = description $ fromJust (decode "{\"description\":\"andy\", \"color\":\"blue\", \"size\":\"28w\", \"photo\":\"asdfasdf\"}" :: Maybe Shoe)
