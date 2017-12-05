-- :name create-users-table
-- :command :execute
-- :result :raw
CREATE TABLE IF NOT EXISTS users (
  id                BIGSERIAL PRIMARY KEY,
  first_name        VARCHAR(50),
  last_name         VARCHAR(50),
  registration_date TIMESTAMP
);

-- :name all-users :?
SELECT *
FROM users;

-- :name add-user :<! :1
INSERT INTO users (first_name, last_name, registration_date)
VALUES (:first-name, :last-name, :registration-date)
RETURNING id;

-- :name drop-users-table :!
DROP TABLE IF EXISTS users;
