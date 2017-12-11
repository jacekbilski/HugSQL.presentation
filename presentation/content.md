### **HugSQL** for accessing RDBMS'

<br>

#### a.k.a. there's life beyond Datomic



### About me

<br>

Jacek Bilski

<br>

Consultant @ <img src="innoQ.svg" alt="innoQ" style="transform: translateY(25px);">

<br>

[http://jacekbilski.blogspot.com/](http://jacekbilski.blogspot.com/)



### Highlights


#### You write your queries in SQL


#### They show up in Clojure code as functions

<br>

surprise ;)



### Crash course


#### Import

<br>

In `project.clj`:

```clojure
[com.layerware/hugsql "0.4.8"]
```

plus something like

```clojure
[org.postgresql/postgresql "42.1.4"]
```


#### Write your queries

<br>

In, say, `resources/sql/users.sql`:

```sql
-- :name all-users :?
SELECT *
FROM users;
```


#### Clojure binding code

<br>

In, say, `src/app/db/users.clj`:

```clojure
(ns app.db.users
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/users.sql" {:quoting :ansi})
```


#### Use

<br>

In, say, `src/app.clj`:

```clojure
(ns app
  (:require [app.db.users :as users]))

(def db {:dbtype "postgresql"
         :dbname "dbname"
         :user "dbuser"
         :password "pass"})

(println (users/all-users db))
```


#### Result

<br>

Something like:

```clojure
({:id 1, 
  :first_name Jacek, 
  :last_name Bilski, 
  :reg_date #inst "2017-12-05T16:27:19"})
```



### OK, some more details



### Creating a table broken down


#### SQL

```sql
-- :name create-users-table :!
CREATE TABLE IF NOT EXISTS users (
  id         BIGSERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name  VARCHAR(50),
  reg_date   TIMESTAMP);
```

Longer form:

```sql
-- :name create-users-table
-- :command :execute
```


#### Clojure binding code (again)

```clojure
(ns app.db.users
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/users.sql" {:quoting :ansi})
```


#### Usage

Import:
```clojure
(ns app
  (:require [app.db.users :as users]))
```

Define database:
```clojure
(def db {:dbtype "postgresql"
         :dbname "dbname"
         :user "dbuser"
         :password "pass"})
```

Use:
```clojure
(users/create-users-table db)
```



### Adding new user broken down


#### SQL

```sql
-- :name add-user :!
INSERT INTO users (first_name, last_name, reg_date)
VALUES (:first-name, :last-name, :reg-date);
```


#### SQL with `RETURNING`

```sql
-- :name add-user :<! :1
INSERT INTO users (first_name, last_name, reg_date)
VALUES (:first-name, :last-name, :reg-date)
RETURNING id;
```

Longer form:

```sql
-- :name add-user
-- :returning-execute :one
```


#### Clojure binding code (still no changes)

```clojure
(ns app.db.users
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/users.sql" {:quoting :ansi})
```


#### Usage

```clojure
(users/add-user db 
  {:first-name "Jacek"
   :last-name "Bilski"
   :reg-date (Timestamp/from (Instant/now))})
```



### Parameter passing


#### Simple

SQL:

```sql
-- :name add-user :!
INSERT INTO users (first_name, last_name, reg_date)
VALUES (:first-name, :last-name, :reg-date);
```

Clojure:

```clojure
(users/add-user db 
  {:first-name "Jacek"
   :last-name "Bilski"
   :reg-date (Timestamp/from (Instant/now))})
```


#### Deep

SQL:

```sql
-- :name add-with-address :!
INSERT INTO users (first_name, last_name, street, zip, city)
VALUES (:first-name, :last-name,
  :address.street, :address.zip, :address.city);
```

Clojure:

```clojure
(users/add-with-address db {
    :first-name "Jacek"
    :last-name "Bilski"
    :address {:street "Kreuzstr. 16"
              :zip "80331"
              :city "München"}})
```



### Queries


#### Single row

SQL:

```sql
-- :name find-by-id :? :1
SELECT * FROM users WHERE id = :id;
```

Clojure:

```clojure
(println (users/find-by-id db {:id 1}))
```

Result:

```clojure
({:id 1, 
  :first_name Jacek, 
  :last_name Bilski, 
  :reg_date #inst "2017-12-05T16:27:19"})
```


#### Multiple rows

SQL:

```sql
-- :name all-users :? :*
SELECT * FROM users;
```

Clojure:

```clojure
(println (users/all-users db))
```


#### Multiple rows

Result:

```clojure
({:id 1, 
  :first_name Jacek, 
  :last_name Bilski, 
  :reg_date #inst "2017-12-07T22:01:06", 
  :street nil, :zip nil, :city nil}
{:id 2, 
  :first_name Jan, 
  :last_name Stępień, 
  :reg_date nil, 
  :street Kreuzstr. 16, :zip 80331, :city München})
```



#### Transactions

Second parameter can be:

+ db specification
+ db connection
+ db connection pool
+ transaction object

For example:

```clojure
(clojure.java.jdbc/with-db-transaction [tx db]
  (users/add-user tx 
    {:first-name "Jacek", :last-name "Bilski", :reg-date nil})
  (users/add-user tx 
    {:first-name "Jan", :last-name "Stępień", :reg-date nil}))
```



### And many more

<br>

+ parameter types
+ snippets
+ clojure expressions
+ access to low level SQL
+ adapters
+ ...



### About

<br>

Main character:

HugSQL, [https://www.hugsql.org/](https://www.hugsql.org/)

<br>

Author:

Jacek Bilski, [http://jacekbilski.blogspot.com/](http://jacekbilski.blogspot.com/)
