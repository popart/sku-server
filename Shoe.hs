{-# LANGUAGE OverloadedStrings #-}
module Shoe (Shoe, description, color, size, photo) where

import Data.Text.Lazy
import Data.Aeson
import Data.Maybe
import Control.Applicative
import Control.Monad

data Shoe = Shoe { description :: Text
                 , color       :: Text
                 , size        :: Text
                 , photo       :: Text } deriving (Show)

instance FromJSON Shoe where
  parseJSON (Object v) =
    Shoe <$> 
        v .: "description" <*> 
        v .: "color"       <*> 
        v .: "size"        <*> 
        v .: "photo"  
  parseJSON _ = mzero

instance ToJSON Shoe where
  toJSON (Shoe description color size photo) =
    object [ "description" .= description
           , "color"       .= color
           , "size"        .= size
           , "photo"       .= photo ]

describe :: Shoe -> Text
describe (Shoe d _ _ _) = d

test :: Text
test = describe $ fromJust (decode "{\"description\":\"andy\", \"color\":\"blue\", \"size\":\"28w\", \"photo\":\"asdfasdf\"}" :: Maybe Shoe)
