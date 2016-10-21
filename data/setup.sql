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

INSERT INTO users (email, first_name, last_name, password, username) VALUES
  ('user@example.com', 'first', 'last', crypt('user-password', gen_salt('bf', 8)), 'username'),
  ('spy@hacker.com', 'Ima', 'Spy', crypt('spy-password', gen_salt('bf', 8)), 'spy'),
  ('tobin@example.com', 'Tobin', 'Quadros', crypt('tobinq-password', gen_salt('bf', 8)), 'tobinq');
