{-# LANGUAGE OverloadedStrings #-}
module Sku where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import Data.Int
import Data.Text.Lazy
import Data.Aeson
import Control.Applicative
import Control.Monad

data Sku = Sku { did         :: Maybe Int
               , description :: Maybe Text
               , color       :: Maybe Text 
               , size        :: Maybe Text
               , photo       :: Maybe Text
} deriving (Show)

instance FromRow Sku where
  fromRow = Sku <$> field <*> field <*> field <*> field <*> field

instance ToRow Sku where
  toRow (Sku did d c s p) = 
    [toField d, toField c, toField s, toField p]

instance ToJSON Sku where
  toJSON (Sku did description color size photo) =
    object [ "did"         .= did 
           , "description" .= description
           , "color"       .= color
           , "size"        .= size
           , "photo"       .= photo ]

instance FromJSON Sku where
  parseJSON (Object v) =
    Sku <$> v .:? "did"         <*>
            v .:? "description" <*> 
            v .:? "color"       <*> 
            v .:? "size"        <*> 
            v .:? "photo"  
  parseJSON _ = mzero
             
getSkus :: Connection -> IO [Sku]
getSkus c = 
  query_ c "SELECT did, description, color, size, photo FROM sku ORDER BY did"

getSku :: Connection -> Int -> IO [Sku]
getSku c did = 
  query c 
        "SELECT did, description, color, size, photo FROM sku WHERE did = ?"
        (Only did)

addSku :: Connection -> Sku -> IO [Sku]
addSku c sku
  | did sku == Nothing =
    query c
          "INSERT INTO sku (description, color, size, photo) \
          \ VALUES (?, ?, ?, ?) RETURNING did, description, color, size, photo"
          sku
  | otherwise =
    query c
          "UPDATE sku SET (description, color, size, photo) \
          \ = (?, ?, ?, ?) WHERE did = ? \
          \ RETURNING did, description, color, size, photo"
          ((toRow sku) ++ [toField (did sku)])

-- manual tests
testConn = connect defaultConnectInfo  {
  connectDatabase = "demo"
}

test = do 
    c <- testConn
    ss <- getSkus c
    return (encode ss)

jsonTestStr = "{\"did\":123, \"description\":\"andy\", \"color\":\"blue\", \"size\":\"28w\", \"photo\":\"asdfasdf\"}"
test2 = decode "{\"description\":\"andy\", \"color\":\"blue\", \"size\":\"28w\", \"photo\":\"asdfasdf\"}" :: Maybe Sku

test3 = decode jsonTestStr :: Maybe Object
test4 = decode jsonTestStr :: Maybe Sku

toRowTest (Just sku) = toRow sku
test5 = toRowTest test4
test6 = toRowTest test2

testAddSku = do 
  c <- testConn
  addSku c testSku1 
  addSku c testSku2
  where
    testSku1 = Sku { did = Just 999
                   , description = Just "999th Sku"
                   , color = Just "RED"
                   , size = Just "infinite"
                   , photo = Just "(:[])" }
    testSku2 = Sku { did = Nothing
                   , description = Just "999th Sku"
                   , color = Just "RED"
                   , size = Just "infinite"
                   , photo = Just "(:[])" }
