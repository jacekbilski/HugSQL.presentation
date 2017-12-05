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

<br>

```sql
-- :name all-users :?
SELECT *
FROM users;
```


### Clojure binding code

<br>

In, say, `src/app/db/users.clj`:

<br>

```clojure
(ns app.db.users
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/users.sql" {:quoting :ansi})
```


### Use

<br>

In, say, `src/app.clj`:

<br>

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

Something like:

```clojure
({:id 1, :first_name Jacek, :last_name Bilski, :registration_date #inst "2017-12-05T16:27:19.828000000-00:00"})
```
