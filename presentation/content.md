## **HugSQL** for accessing RDBMS'

<br>

### a.k.a. there's life beyond Datomic



## Highlights


### You write your queries in SQL


### They show up in Clojure code as functions

<br>

surprise ;)



## Crash course


### Import

<br>

In `project.clj`:

```clojure
[com.layerware/hugsql "0.4.8"]
```

plus something like

```clojure
[org.postgresql/postgresql "42.1.4"]
```


### Write your queries

<br>

In, say, `resources/sql/users.sql`:

```sql
-- :name all-users :?
SELECT *
FROM users;
```


### Clojure binding code

<br>

In, say, `src/app/db/users.clj`:

```clojure
(ns app.db.users
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/users.sql" {:quoting :ansi})
```


### Use

<br>

In, say, `src/app.clj`:

```clojure
(ns app
  (:gen-class)
  (:require [app.db.users :as users]))

(def db
  {:dbtype "postgresql"
   :dbname "dbname"
   :user "dbuser"
   :password "pass"})

(defn -main
  [& args]
  (println (users/all-users db)))
```


### Result

<br>

Something like:

```clojure
({:id 1, :first_name Jacek, :last_name Bilski, :registration_date #inst "2017-12-05T16:27:19.828000000-00:00"})
```



## OK, some more details



## Creating a table broken down


### SQL

<br>

```sql
-- :name create-users-table
-- :command :execute
CREATE TABLE IF NOT EXISTS users (
  id                BIGSERIAL PRIMARY KEY,
  first_name        VARCHAR(50),
  last_name         VARCHAR(50),
  registration_date TIMESTAMP
);
```

<br>

Shorter form:

```sql
-- :!
```


### Clojure binding code (again)

<br>

```clojure
(ns app.db.users
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/users.sql" {:quoting :ansi})
```


### Usage

<br>

```clojure
(users/create-users-table db)
```



## Adding new user broken down


### SQL

<br>

```sql
-- :name add-user :!
INSERT INTO users (first_name, last_name, registration_date)
VALUES (:first-name, :last-name, :registration-date);
```


### SQL with `RETURNING`

<br>

```sql
-- :name add-user :returning-execute :one
INSERT INTO users (first_name, last_name, registration_date)
VALUES (:first-name, :last-name, :registration-date)
RETURNING id;
```

Shorter form:

```sql
-- :<! :1
```


### Clojure binding code (again, still no changes)

<br>

```clojure
(ns app.db.users
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/users.sql" {:quoting :ansi})
```


### Usage

<br>

```clojure
(users/add-user db {:first-name "Jacek", :last-name "Bilski", :registration-date (Timestamp/from (Instant/now))})
```



## Parameter passing


### Simple

<br>

SQL:

```sql
-- :name add-user :!
INSERT INTO users (first_name, last_name, registration_date)
VALUES (:first-name, :last-name, :registration-date);
```

Clojure:

```clojure
(users/add-user db {:first-name "Jacek", :last-name "Bilski", :registration-date (Timestamp/from (Instant/now))})
```


### Deep

<br>

SQL:

```sql
-- :name add-with-address :!
INSERT INTO users (first_name, last_name, street, zip, city)
VALUES (:first-name, :last-name, :address.street, :address.zip, :address.city);
```

Clojure:

```clojure
(users/add-with-address db {
    :first-name "Jacek", 
    :last-name "Bilski", 
    :address {:street "Kreuzstr. 16", :zip "80331", :city "München"}})
```



## Queries


### Single row

<br>

SQL:

```sql
-- :name find-by-id :? :1
SELECT *
FROM users 
WHERE id = :id;
```

Clojure:

```clojure
(println (users/find-by-id db {:id 1}))
```

Result:

```clojure
({:id 1, :first_name Jacek, :last_name Bilski, :registration_date #inst "2017-12-05T16:27:19.828000000-00:00"})
```


### Multiple rows

<br>

SQL:

```sql
-- :name all-users :? :*
SELECT *
FROM users;
```

Clojure:

```clojure
(println (users/all-users db))
```

Result:

```clojure
({:id 1, :first_name Jacek, :last_name Bilski, :registration_date #inst "2017-12-07T22:01:06.899000000-00:00", 
    :street nil, :zip nil, :city nil}
{:id 2, :first_name Jacek, :last_name Bilski, :registration_date nil, 
    :street Kreuzstr. 16, :zip 80331, :city München})
```



### Transactions

<br>

Second parameter can be:

+ db specification
+ db connection
+ db connection pool
+ transaction object

<br>

For example:

```sql
(clojure.java.jdbc/with-db-transaction [tx db]
  (users/add-user tx {:first-name "Jacek", :last-name "Bilski", :registration-date nil})
  (users/add-user tx {:first-name "Jan", :last-name "Stępień", :registration-date nil}))
```



## And many more
