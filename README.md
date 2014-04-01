sku-server
==========

This project requires PostgreSQL.  You can setup the database from the db_setup.sql script.

Setup db (for example):
```
psql postgres -U postgres -f db_setup.sql
```


Install and run:
```
cabal install
/path/to/sku-server
```


Then just load/open the webroot/index.html in a browser!
