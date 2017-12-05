(ns app.db
  (:require [hugsql.core :as hugsql]))

(def db
  {:dbtype "postgresql"
   :dbname "test"
   :user "dbuser"
   :password "password"})
