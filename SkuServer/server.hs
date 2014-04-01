{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty

 -- install wai-extra if you don't have this
import Network.Wai.Middleware.RequestLogger

import Control.Monad.Trans

import qualified Data.Aeson as Aeson
import Data.Maybe
import SkuServer.Sku

import Database.PostgreSQL.Simple
import Network.HTTP.Types.Method

conn = connect defaultConnectInfo  {
  connectDatabase = "demo"
}

main :: IO ()
main = do
  c <- conn
  scotty 3000 $ do
    -- Add any WAI middleware, they are run top-down.
    middleware logStdoutDev

    get "/" $ text "Server is up!"

    -- CORS headers (called before a PUT)
    addroute OPTIONS "/sku/" $ do
        setHeader "Access-Control-Allow-Origin" "*" 
        setHeader "Access-Control-Allow-Headers" "Content-Type" 
        setHeader "Access-Control-Allow-Methods" "GET, PUT, OPTIONS"

    -- create or modify sku
    put "/sku/" $ do
        b <- body
        case (Aeson.decode b :: Maybe Sku) of
          Just s -> liftIO (addSku c s) >>= json
          Nothing -> raise "bad parse"
        setHeader "Access-Control-Allow-Origin" "*" 

    -- get sku by 'did'
    get "/sku/:did" $ do
        did <- param "did"
        liftIO (getSku c did) >>= json
        setHeader "Access-Control-Allow-Origin" "*" 
        
    -- get all skus
    get "/sku/" $ do
        liftIO (getSkus c) >>= json
        setHeader "Access-Control-Allow-Origin" "*" 
