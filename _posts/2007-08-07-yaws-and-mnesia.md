---
layout: post
title: Yaws and Mnesia
tags: database, erlang
---

I'm playing with translating a small Web application from
[Rails](http://www.rubyonrails.org/) to the Erlang web app framework
[Yaws](http://yaws.hyber.org/). When I tried to access a Mnesia database
from a page, it failed because Mnesia wasn't running. Oops. I tried running
it from another erl shell, but that didn't work.

After asking on
[erlang-questions](http://www.erlang.org/mailman/listinfo/erlang-questions),
here's what I've learned from the responses: You can tell Yaws about Mnesia
by using the command line switch `--mnesiadir full-path-to-mnesia-directory`
(but that only works when yaws is running as a daemon).

Or, you can connect to the yaws (erl) runtime and start Mnesia from there.
If you started Yaws with `-sname` and a cookie you can connect to it like
any other Erlang runtime.

Finally, the simplest way to do this is to run yaws from the command line
and start mnesia from within the yaws session. That's what I've done.

Thanks to the members of erlang-questions for their help.
