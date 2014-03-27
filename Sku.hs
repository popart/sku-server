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

conn = connect defaultConnectInfo  {
  connectDatabase = "demo"
}

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
  query_ c "SELECT did, description, color, size, photo FROM sku"

queryFail :: Connection -> IO [Only Int]
queryFail c =
  query_ c "select did from sku limit 1"

test = do 
    c <- conn
    ss <- getSkus c
    return (encode ss)

jsonTestStr = "{\"did\":123, \"description\":\"andy\", \"color\":\"blue\", \"size\":\"28w\", \"photo\":\"asdfasdf\"}"
test2 = decode "{\"description\":\"andy\", \"color\":\"blue\", \"size\":\"28w\", \"photo\":\"asdfasdf\"}" :: Maybe Sku

test3 = decode jsonTestStr :: Maybe Object
test4 = decode jsonTestStr :: Maybe Sku

toRowTest (Just sku) = toRow sku
test5 = toRowTest test4
test6 = toRowTest test2

addSku :: Connection -> Sku -> IO [Sku]
addSku c sku
  | did sku == Nothing =
    query c
          "INSERT INTO sku (description, color, size, photo) \
          \ values (?, ?, ?, ?) returning *"
          sku
  | otherwise =
    query c
          "UPDATE sku SET (description, color, size, photo) \
          \ = (?, ?, ?, ?) WHERE did = ? returning *"
          ((toRow sku) ++ [toField (did sku)])

doIt = do 
  c <- conn
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


