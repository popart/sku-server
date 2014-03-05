{-# LANGUAGE OverloadedStrings #-}
import Style
import Data.Aeson
import Data.Maybe

test = description $ fromJust (decode "{\"description\":\"andy\", \"color\":\"blue\", \"size\":\"28w\", \"photo\":\"asdfasdf\"}" :: Maybe Style)
