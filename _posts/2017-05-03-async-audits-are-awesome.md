---
layout: post
title: "Asynchronous Audits are Awesome"
tags: performance, database, ruby, rails, programming
---

[Audited](https://github.com/collectiveidea/audited) is a Ruby gem that adds
change logging to Rails models. It's great for figuring out what happened to
a model or a group of related models over time.

> This post was originally published
> on [The Dirty Birds](http://dirtybirds.chloeandisabel.com/), the Chloe +
> Isabel tech team blog.

If you have an application that generates a lot of audit records they can
start to slow down your application a bit. Not only do the audit records
have to get written to the database, but since they are versioned the save
process needs to read the database first to get the current max version
number before the new record can be written.

Making these saves asynchronous can improve your Rails app's response times.
Testing with our application showed a 14% speedup with audit-intensive code.
That is of course an anecdote, not data.

We had originally forked the Audited gem and modified it to work with
multiple asynchronous job processing libraries (we
use [Resque](https://github.com/resque/resque)). After we opened
a [pull request](https://github.com/collectiveidea/audited/pull/288) and
some great help from project members, a discussion took place in the PR
about whether the code should be merged into the Audited gem's code base.

After some thoughtful comments pro and con, we decided to close the PR.
Instead, we've come up with a way to do this that is simpler and doesn't
require that the gem be changed at all.

## Show Me the Code!

To force audits to be saved asynchronously we started by monkeypatching the
audit model's `save` method. It puts the data to be saved in the work queue
to be written to the database later.

We use [Resque](https://github.com/resque/resque) to manage work queues and
perform work asynchronously.


This code lives in `config/initializers/audited.rb`. (Note that this is not
the final version.)

```ruby
module Audited
  class Audit
    alias_method :orig_save, :save

    def save(*_args)
      Resque.enqueue(AuditingJob::AsyncSave, attributes)
      true
    end
  end
end
```

The asynchronous job does the actual save, using `orig_save`.

```ruby
class AuditingJob::AsyncSave
  # ...boilerplate removed...

  def self.perform(audit_attributes)
    Audited::Audit.new(audit_attributes).orig_save
  end
end
```

This works, but if you run this you'll notice at least two problems. First,
the `created_at` is set during the save in the asynchronous job which means
that it is not the time that the original audit record's `save` method was
called. Second, the fields related to the user who made the audit and the
request itself (IP address and request UUID) are blank. That's because the
Audit gem's save code gets that information from Rails' current controller.
The problem is that inside this asynchronous job there is no "current
controller".

The solution is to set those values in the monkeypatched `save` method.
Setting the `created_at` attribute directly is easy. As for the other
values, though the save method doesn't directly have access to the current
controller the Audited gem already has a way to get it. We can use that to
get information about the current user and the request.

One final thing we need to do is muck with the datetime attributes before
sending the to the async job. Datetimes are serialized as strings, but the
string format of a Time object is not directly readable by the database. So
we turn it into a format readable by the database. (We're jumping ahead a
bit &mdash; we will be using a SQL INSERT directly; see below.)

Here's a modified version of the monkeypatched `save` method:

```ruby
module Audited
  class Audit
    alias_method :orig_save, :save

    def save(*_args)
      self.created_at ||= Time.current
      ctl = Audited.store[:current_controller]
      if ctl
        self.user_id ||= ctl.current_user&.id
        self.user_type ||= ctl.current_user&.class&.name
        self.request_uuid ||= ctl.request&.uuid
        self.remote_address ||= ctl.request&.remote_ip
      end
      self.username ||= self.user&.email

      # Need to hack datetime values so they're encoded properly
      attrs = attributes
      attrs["created_at"] = attrs["created_at"].to_s(:db)

      Resque.enqueue(AuditingJob::AsyncSave, attrs)
      true
    end
  end
end
```

We're using Ruby's safe navigation operator (`&.`) which was introduced in
Ruby 2.3.0. If you're running an earlier version of Ruby you can use the
Rails `try` method instead.

Now that we've set all of these values, we need to prevent Audited from
overwriting them when it saves the record in our asynchronous job. To do
that, we use a SQL INSERT statements instead of calling the Audited model's
`save` (via `orig_save`). That means we have to not only create the INSERT
statement but also determine the version number for the record we are about
to save.

Here's the new version of the asynchronous job:

```ruby
class AuditingJob::AsyncSave
  # ... boilerplate removed...

  def self.perform(audit_attributes)
    # Using raw SQL is not only simpler, but it also bypasses Audited code
    # that (re)sets some values we don't want touched.
    Audited::Audit.transaction do
      audit_attributes["version"] =
        get_version(audit_attributes["auditable_id"], audit_attributes["auditable_type"])
      conn = Audited::Audit.connection
      column_names = audit_attributes.keys
      safe_values = audit_attributes.values.map { |v| conn.quote(v) }
      conn.execute "INSERT INTO #{Audited::Audit.table_name} (#{column_names.join(", ")})" +
                   " VALUES (#{safe_values.join(", ")})"
    end
  end

  def self.get_version(auditable_id, auditable_type)
    return 1 unless auditable_id && auditable_type

    curr_version = Audited::Audit
                     .where(auditable_id: auditable_id, auditable_type: auditable_type)
                     .maximum(:version)
    (curr_version || 0) + 1
  end
end
```

That's it.
