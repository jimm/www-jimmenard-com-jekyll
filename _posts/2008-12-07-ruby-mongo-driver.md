---
layout: post
title: Ruby Mongo driver
tags: 10gen database mongo ruby programming opensource cloud java
---

I've been working on a
[pure-Ruby driver](https://github.com/jimm/mongo-ruby-driver/tree/master) for
[Mongo](http://www.mongodb.org/), 10gen's document database. If you are of
the Java persuasion, then check out Geir Magnusson Jr's
[Java driver](https://github.com/geir/mongo-java-driver/tree/master) for
Mongo.

One thing that we are discussing internally at 10gen is which layer of the
system should be responsible for automatically creating primary key fields
for records. Mongo does not require them, but Babble (the 10gen cloud
computing app server) does. I think what will end up happening is that the
driver will not add them unless the caller specifically asks for it.
