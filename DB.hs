{-# LANGUAGE OverloadedStrings #-}
module DB where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import Data.Text.Lazy
import Data.Int
import Control.Applicative

conn = connect defaultConnectInfo  {
  connectDatabase = "demo"
}

data Shoe = Shoe {
  did          :: Maybe Int  ,
  description :: Maybe Text ,
  color       :: Maybe Text ,
  size        :: Maybe Text ,
  photo       :: Maybe Text
} deriving (Show)

instance FromRow Shoe where
  fromRow = Shoe <$> field <*> field <*> field <*> field <*> field

instance ToRow Shoe where
  toRow (Shoe Nothing d c s p) = [toField d, toField c, toField s, toField p]
  toRow (Shoe did d c s p) = [toField did, toField d, toField c, toField s, toField p]

createShoe :: Connection -> Shoe -> IO Int64
createShoe c s = 
  execute c
  "INSERT INTO shoes (description, color, size, photo) \
  \ values (?, ?, ?, ?)"
  s 

test = do
  c <- conn
  print shoe
  createShoe c shoe
  where shoe = Shoe {did= Nothing,
                     description = Just "shoe1",
                     color = Just "blue",
                     size = Just "SIZE",
                     photo = Just "photo" }
