{-# LANGUAGE OverloadedStrings #-}
module Style where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import Data.Int
import Data.Text.Lazy
import Data.Aeson
import Control.Applicative
import Control.Monad

conn = connect defaultConnectInfo  {
  connectDatabase = "demo"
}

data IdResult = IdResult { val :: Int } deriving (Show)
instance FromRow IdResult where
    fromRow = IdResult <$> field

data Style = Style { did         :: Maybe Int
                   , description :: Maybe Text
                   , color       :: Maybe Text 
                   , size        :: Maybe Text
                   , photo       :: Maybe Text
} deriving (Show)

instance FromRow Style where
  fromRow = Style <$> field <*> field <*> field <*> field <*> field

instance ToRow Style where
  toRow (Style did d c s p) = 
    [toField d, toField c, toField s, toField p]

instance ToJSON Style where
  toJSON (Style did description color size photo) =
    object [ "did"         .= did 
           , "description" .= description
           , "color"       .= color
           , "size"        .= size
           , "photo"       .= photo ]

instance FromJSON Style where
  parseJSON (Object v) =
    Style <$> 
        v .:? "did"         <*>
        v .:? "description" <*> 
        v .:? "color"       <*> 
        v .:? "size"        <*> 
        v .:? "photo"  
  parseJSON _ = mzero
             
getStyles :: Connection -> IO [Style]
getStyles c = 
  query_ c "SELECT did, description, color, size, photo FROM style"

test = do {
    c <- conn;
    styles <- getStyles c;
    return $ toJSON $ Prelude.head $Prelude.tail styles
}

jsonTestStr = "{\"did\":123, \"description\":\"andy\", \"color\":\"blue\", \"size\":\"28w\", \"photo\":\"asdfasdf\"}"
test2 = decode "{\"description\":\"andy\", \"color\":\"blue\", \"size\":\"28w\", \"photo\":\"asdfasdf\"}" :: Maybe Style

test3 = decode jsonTestStr :: Maybe Object
test4 = decode jsonTestStr :: Maybe Style

toRowTest (Just style) = toRow style
test5 = toRowTest test4
test6 = toRowTest test2

addStyle :: Connection -> Style -> IO [IdResult]
addStyle c style
    | did style == Nothing =
          query c
          "INSERT INTO style (description, color, size, photo) \
          \ values (?, ?, ?, ?) returning did"
          style
    | otherwise =
          query c
          "UPDATE style SET (description, color, size, photo) \
          \ = (?, ?, ?, ?) WHERE did = ? returning did"
          ((toRow style) ++ [toField (did style)])

wongStyle = Style { did = Nothing
                   , description = Just "999th Style"
                   , color = Just "RED"
                   , size = Just "infinite"
                   , photo = Just "(:[])" }
doIt = do 
    c <- conn
    addStyle c testStyle1 
    addStyle c testStyle2 
  where
    testStyle1 = Style { did = Just 999
                             , description = Just "999th Style"
                             , color = Just "RED"
                             , size = Just "infinite"
                             , photo = Just "(:[])" }
    testStyle2 = Style { did = Nothing
                       , description = Just "999th Style"
                       , color = Just "RED"
                       , size = Just "infinite"
                       , photo = Just "(:[])" }


