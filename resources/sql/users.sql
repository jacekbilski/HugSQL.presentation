-- :name create-users-table
-- :command :execute
CREATE TABLE IF NOT EXISTS users (
  id                BIGSERIAL PRIMARY KEY,
  first_name        VARCHAR(50),
  last_name         VARCHAR(50),
  registration_date TIMESTAMP,
  street            VARCHAR(50),
  zip               VARCHAR(5),
  city              VARCHAR(50)
);

-- :name all-users :? :*
SELECT *
FROM users;

-- :name add-user :<! :1
INSERT INTO users (first_name, last_name, registration_date)
VALUES (:first-name, :last-name, :registration-date)
RETURNING id;

-- :name add-with-address :!
INSERT INTO users (first_name, last_name, street, zip, city)
VALUES (:first-name, :last-name, :address.street, :address.zip, :address.city);

-- :name drop-users-table :!
DROP TABLE IF EXISTS users;
