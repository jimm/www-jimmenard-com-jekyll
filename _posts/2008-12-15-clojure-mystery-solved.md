---
layout: post
title: Clojure Mystery Solved
tags: 10gen, database, mongo, programming, clojure
---

I figured out [what was wrong](file:../../2008/12/clojure.html) with the
Clojure code in the
[Mongo Java Driver](http://github.com/geir/mongo-java-driver/tree/master)
Clojure sample: we weren't turning the value returned by the database into a
seq. You can see the fixed version
[here.](http://github.com/geir/mongo-java-driver/tree/master/src/examples/clojure/mongo.clj)
