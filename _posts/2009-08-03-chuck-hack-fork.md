---
layout: post
title: ChucK Hack Fork
tags: audio, c++, music, programming, midi
---

I've created a GitHub fork of [ChucK](http://chuck.cs.princeton.edu/), the
"strongly-timed, concurrent, and on-the-fly audio programming language." In
[my fork](https://github.com/jimm/chuck) I've started to add missing features
like string methods, and hope to add many more such as raw file I/O and
perhaps some form of MIDI file I/O.

So far, I've added string.ch which is a getter and setter for string
characters (really one-character length substrings) and string.substr. This
allowed me to write a function in ChucK that converts strings like "c#4" to
MIDI note numbers.

It looks like ChucK's code was last updated in 2006, so I don't feel to bad
about forking it.

_Update_: I just read in the chuck email list archive that the team is
planning to start active development again, and they will be adding file
I/O. If they get it done before I do, that would be very nice.
