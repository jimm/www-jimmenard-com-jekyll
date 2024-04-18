---
layout: post
title: Learning a New Programming Language
tags: erlang programming
---

I'm a self-professed language maven. I love learning new programming
languages. Recently, I've been learning [Erlang](http://www.erlang.org/),
thanks to [Programming Erlang](http://books.pragprog.com/titles/jaerlang/)
by Joe Armstrong, the online documentation, and the Erlang mailing list.

I'm a hands-on learner (see
[Just Try It](../../../2006/12/05/just-try-it.html]). For me, there are a
few phases to learning a new language:

- Overview
- Installation and Documentation
- Syntax
- Standard libraries
- Philosophy
- Frameworks

These phases don't occur sequentially; they blur together. For example, when
trying to absorb what I call the philosophy of a language, I'll be writing
code that forces me to look for how to use the standard libraries and look
for existing frameworks.

The _overview_ phase is when I initially hear about a language. It might be
through posts in mailing lists or discussions groups, the various RSS feeds
to which I subscribe, or on [Reddit](http://reddit.com/). During this phase
I tend to form a few first impressions about a language: is it really
different? How? Why does it exist? Will it be useful to me in my day-to-day
work? Is it worth learning to exercise my brain, or because I will learn new
concepts?

Next comes _installation and documentation_. I grab a copy of the language
and whatever documentation I can. This is a key step: if I can't install the
language or get it running, or if the documentation doesn't give me enough
information to get started, then I'm done.

Learning the _syntax_ gets me as far as being able to follow along with a
book or the documentation. This is also another place for me to be turned
off by a language. For example, when I started playing with Python, I
decided it wasn't for me for a few reasons: significant whitespace, the
`__funky__` naming convention for magic OO methods, and having to refer to
`self` all the time. Please remember, Pythonistas (all one of you that might
read this :-), that I'm talking about my impressions and my decisions, not
yours or anybody else's.

I'm not sure what made me temporarily abandon Scala (see
[Scala Baby-Steps](../../../2007/01/09/scala-baby-steps.html]) for Erlang.
Partly, I was seeing references to Erlang when reading about Scala. Partly,
it felt a bit less developed and complete then Erlang. Mostly, I think I'm
learning more new things with Erlang.

Becoming familiar with a language's _standard libraries_ or classes lets me
know what comes "out of the box", as opposed to what I'll have to go look
for or build for myself. It also gives me a good sense of the language's
approach to solving various kinds of problems, large and small, and at
different levels (from one-liners like iterating through a list through
larger libraries like parsers or network communications). Again, the
libraries can be make-or-break for me: while playing with Python, I found
that simple string and regular expression operations were too difficult to
find. (Actually, this is a problem with Erlang, too: string operations are
all over the place in different libraries. One place for making a string
upper case, another for making it lower case.)

By _philosophy_ I mean a few different things: what the language is best at
(and worst at), what it was designed for, what its strengths and weaknesses
are, and what good code in the language looks like. Philosophy often, but
not always, goes hand-in-hand with learning the syntax and the standard
libraries.

During this phase, I usually pick for myself a small number of decent-sized
tasks. By this time, I've been writing code in the new language for a while,
but mostly toy exercises. It's time to write a larger program. Usually I
take a project I've already written in a few different languages and port it
to the new language. The code starts as a straight port, but as I progress I
try to rewrite it using the idioms and techniques offered by the new
language.

By this time, I've usually look for and found a few different language
_frameworks_ on the order of as a Web application server or app development
framework. This gives me an idea not only of what's available, but what the
community is like.

Speaking of community, by this time I've probably joined the language's
primary mailing list.

I plan to blog about three different projects I've been working on in
Erlang: a MIDI file reader/writer, a
[Boids](http://en.wikipedia.org/wiki/Boids) simulation, and a simple Web
application using Erlyweb.
