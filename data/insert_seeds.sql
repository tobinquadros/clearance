INSERT INTO users (email, first_name, last_name, password, username) VALUES
  ('user@example.com', 'first', 'last', crypt('user-password', gen_salt('bf', 8)), 'username'),
  ('spy@hacker.com', 'Ima', 'Spy', crypt('spy-password', gen_salt('bf', 8)), 'spy'),
  ('tobin@example.com', 'Tobin', 'Quadros', crypt('tobinq-password', gen_salt('bf', 8)), 'tobinq');
