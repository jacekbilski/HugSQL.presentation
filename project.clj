(defproject app.clj "0.1.0-SNAPSHOT"
  :dependencies [[org.clojure/clojure "1.9.0"]
                 [com.layerware/hugsql "0.4.8"]
                 [org.postgresql/postgresql "42.1.4"]]
  :main ^:skip-aot app
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
