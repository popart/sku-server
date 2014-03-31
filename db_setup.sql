DROP DATABASE IF EXISTS demo;
CREATE DATABASE demo;
\c demo

DROP TABLE IF EXISTS sku;
CREATE TABLE sku (
  did SERIAL PRIMARY KEY,
  description varchar,
  size varchar,
  color varchar,
  photo varchar
);
