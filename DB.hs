{-# LANGUAGE OverloadedStrings #-}
module DB where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import Data.Int
import Data.Text.Lazy
import Control.Applicative
import Data.Aeson

conn = connect defaultConnectInfo  {
  connectDatabase = "demo"
}

data Style = Style { did         :: Int
                   , description :: Text
                   , color       :: Text 
                   , size        :: Text
                   , photo       :: Maybe Text
} deriving (Show)

instance FromRow Style where
  fromRow = Style <$> field <*> field <*> field <*> field <*> field

instance ToJSON Style where
  toJSON (Style did description color size photo) =
    object [ "did"         .= did 
           , "description" .= description
           , "color"       .= color
           , "size"        .= size
           , "photo"       .= photo ]
             
getStyles :: Connection -> IO [Style]
getStyles c = 
  query_ c "SELECT did, description, color, size, photo FROM style"

test = do {
    c <- conn;
    styles <- getStyles c;
    return $ toJSON $ Prelude.head $Prelude.tail styles
}
{-
instance ToRow Style where
  toRow (Style Nothing d c s p) = [toField d, toField c, toField s, toField p]
  toRow (Style did d c s p) = [toField did, toField d, toField c, toField s, toField p]

createStyle :: Connection -> Style -> IO Int64
createStyle c s = 
  execute c
  "INSERT INTO styles (description, color, size, photo) \
  \ values (?, ?, ?, ?)"
  s 
test = do
  c <- conn
  print style
  createStyle c style
  where style = Style {did= Nothing,
                     description = Just "style1",
                     color = Just "blue",
                     size = Just "SIZE",
                     photo = Just "photo" }
-}
