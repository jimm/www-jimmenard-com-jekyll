---
layout: post
title: Phoenix - Seeding Your Tests
tags: elixir, phoenix, testing, database
---

If you need to seed your test database when running
[Phoenix](http://www.phoenixframework.org/) tests, you can require the seed
file in `test/test_helper.exs`:

{% highlight elixir %}
ExUnit.start

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
# Add this line:
Code.require_file("priv/repo/seeds.exs")
Ecto.Adapters.SQL.begin_test_transaction(Expensive.Repo)
{% endhighlight %}

You can, of course, require a different file instead.
