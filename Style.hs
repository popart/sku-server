{-# LANGUAGE OverloadedStrings #-}
module Style (Style, description, color, size, photo) where

import Data.Text.Lazy
import Data.Aeson
import Data.Maybe
import Control.Applicative
import Control.Monad

data Style = Style { description :: Text
                 , color       :: Text
                 , size        :: Text
                 , photo       :: Text } deriving (Show)

instance FromJSON Style where
  parseJSON (Object v) =
    Style <$> 
        v .: "description" <*> 
        v .: "color"       <*> 
        v .: "size"        <*> 
        v .: "photo"  
  parseJSON _ = mzero

instance ToJSON Style where
  toJSON (Style description color size photo) =
    object [ "description" .= description
           , "color"       .= color
           , "size"        .= size
           , "photo"       .= photo ]

describe :: Style -> Text
describe (Style d _ _ _) = d

test :: Text
test = describe $ fromJust (decode "{\"description\":\"andy\", \"color\":\"blue\", \"size\":\"28w\", \"photo\":\"asdfasdf\"}" :: Maybe Style)
