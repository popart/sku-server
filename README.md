sku-server
==========

This project requires PostgreSQL.  You can setup the database from the db_setup.sql script.

Setup db (for example):
```
postgres -D /usr/local/pgsql/data
psql postgres -U postgres -f db_setup.sql
```

Install and run server:
```
cabal install
/path/to/sku-server
```

Then just load the webroot/index.html in a browser!
```
chrome webroot/index.html
```
or (on OSX)
```
open -a chrome webroot/index.html
```
