---
layout: post
title: Play Framework Configuration
tags: rails, programming, opensource, frameworks, video, java
---

I've been using the [Play framework](http://www.playframework.org/) for a
big project at work. It's fantastic. I almost hesitate to say it, but it's
like Ruby on Rails for Java. Watch the video that's on the home page; it's a
good quick introduction.

The Tech Ops team at work wants control over configuration of the app. This
makes sense for a few reasons. First, they're responsible for running it so
they should be able to tweak things like memory settings. Second, they need
to tell the app where the database lives, what the password is, etc. Tech
Ops also wants the app to run as a WAR inside an app server. That's fine:
Play comes with a `war` command that bundles your app into either an
exploded WAR or a WAR file.

The problem is, Play doesn't know how to read any configuration file other
than the one that's in its `conf` directory. At least, that's what I
thought. It turns out there is an undocumented feature of Play configuration
files: If any configuration key is named`@include.FOO`, then the
value is used as a path and that file is read, too.

A few caveats.

- The path is relative to the application directory within the WAR. So, for
  example, to find a file in Tomcat's `conf` directory, the path will have
  to be something like `../../../../../conf/play.conf`.

- The file that gets included isn't treated exactly like the normal
  configuration file. Magic values like `${play.path}` and
  `${application.path}` are not interpreted.

- The current Play framework id (similar to Rails' environment) is ignored.
  However, since the include code is run after everything else is loaded,
  this isn't really a problem since the external configuration file you're
  loading is presumably for the environment you're running.

There is also a plugin architecture, and a hook that runs after the
configuration file is read. This means that, even if
`@include.FOO` didn't exist, you can write a plugin to do
anything you want to alter the app's configuration.

_Update_: Core Play developer Guillaume Bort wrote on the email list, "This
feature is not yet documented because it is not ready: as you observed it
the placeholders and the framework id stuff are not handled properly."
Caveat emptor.
