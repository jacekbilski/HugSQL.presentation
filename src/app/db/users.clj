(ns app.db.users
  (:require [hugsql.core :as hugsql]))

(hugsql/def-db-fns "sql/users.sql" {:quoting :ansi})
