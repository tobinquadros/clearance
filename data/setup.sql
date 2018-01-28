CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  created_at timestamp without time zone NOT NULL DEFAULT (now() at time zone 'utc'),
  email varchar(64) UNIQUE NOT NULL,
  first_name varchar(64),
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  last_name varchar(64),
  password varchar(128) NOT NULL,
  username varchar(64) UNIQUE NOT NULL
);
