(ns app
  (:gen-class)
  (:require [app.db :refer [db]]
            [app.db.users :as users])
  (:import (java.util Date)
           (java.sql Timestamp)
           (java.time Instant)))

(defn -main
  [& args]
  (users/drop-users-table db)
  (users/create-users-table db)
  (users/add-user db {:first-name "Jacek", :last-name "Bilski", :registration-date (Timestamp/from (Instant/now))})
  (users/add-with-address db {:first-name "Jacek", :last-name "Bilski", :address {:street "Kreuzstr. 16", :zip "80331", :city "München"}})
  (println (users/all-users db))
  ;(run! println (entries/all-entries-for-feed db {:feed-id 1}))
  )
