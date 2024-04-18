---
layout: post
title: Rails Without ActiveRecord
tags: 10gen database mongo rails ruby programming opensource cloud
---

When we announced Rails support for the [10gen](http://www.10gen.com) cloud
computing platform, we said that ActiveRecord support was not yet included.
This led naturally to the question, "what the heck good is that?"

Actually, you can run Rails without ActiveRecord just fine. Rails has been
designed that way. For an example app that uses the
[Mongo](http://www.mongodb.org) database, see my
[10gen-rorob](https://github.com/jimm/10gen-rorob/tree/master) Rails app.
You might want to use the
[branch that uses Rails 2.2.2](https://github.com/jimm/10gen-rorob/tree/rails222)
instead, because the master branch uses Rails 1.2.6 and the 2.2.2 branch
also has a few more features.

On the other hand, internally we have a subset of ActiveRecord working
already and are working on supporting as much of it as makes sense with a
non-relational database. I already have the Rails app from "Agile Web
Development With Rails" running unchanged.

On the gripping hand, you can run the 10gen cloud yourself, in which case
you can run it with MySQL or any other relational database. In that case,
you can use ActiveRecord unchanged.
