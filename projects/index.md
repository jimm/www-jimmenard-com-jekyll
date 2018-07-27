---
layout: default
title: Projects
permalink: /projects/
---

# Projects

- My [**GitHub projects**](https://github.com/jimm) not otherwise listed
  below:
  - My [Emacs initialization files](https://github.com/jimm/elisp)
  - The [source for this site](https://github.com/jimm/www-jimmenard-com)
  - My experimentation with different languages like
    [Elixir](https://github.com/jimm/elixir),
    [Common Lisp](https://github.com/jimm/common-lisp),
    [Clojure](https://github.com/jimm/clojure),
    and [Crystal](https://github.com/jimm/crystal)
  - [Project Euler](https://github.com/jimm/euler) solutions
  - The [full list](https://github.com/jimm?tab=repositories)

- [**midilib**](https://github.com/jimm/midilib), a pure-Ruby MIDI library
  useful for reading and writing standard MIDI file and manipulating MIDI
  event data.

- [**csvlixir**](https://github.com/jimm/csvlixir), a CSV reader/writer for
  Elixir that operates on files or strings.

- [**PatchMaster**](https://github.com/jimm/patchmaster), real time MIDI
  performance software that allows a musician to totally reconfigure a MIDI
  setup instantaneously and modify the MIDI data while it's being sent.
  PatchMaster is written in Ruby and is cross-platform.

- [**SeaMaster**](https://github.com/jimm/seamaster), a C version of
  PatchMaster that uses the PortMidi library. Much more performant than
  PatchMaster, but doesn't have any way of loading user-written code to
  modify the MIDI stream.

- [**KeyMaster**](https://github.com/jimm/keymaster), a Mac OS X-only version
  of PatchMaster written in Objective C. I wrote it because PatchMaster is
  frankly not fast enough to keep up with large streams of data.

- [**napper**](https://github.com/jimm/napper), a JSON REST API client for
  Elixir. 

- [**DataVision**](http://datavision.sourceforge.net/), a pure-Java database
  reporting tool similar to Crystal Reports.

- [**Bangkok**](http://bangkok.rubyforge.org/) is a Ruby project that reads
  chess game descriptions and re-play the games. Notice of events (moves,
  captures, checks, etc.) are sent to a listener. Bangkok comes with a
  listener that generates a MIDI file. In other words, the chess game is
  turned into music. Bangkok uses [midilib](http://midilib.rubyforge.org/)

- The
  [**Montastic Dashboard widget**](montastic_dashboard/index.html)
  for Mac OS X. [Montastic](http://www.montastic.com/) is "the free website
  monitoring service that doesn't suck."

- [**Subjective C**](https://github.com/jimm/subjective_c), an
  implementation of Objective C that I wrote many years ago — some time
  around 1993. It uses a hand-written parser to find Objective C code and
  turn it into ANSII C.

- [**Squeak PostgreSQL**](squeak_postgresql/index.html), a
  PostgreSQL database interface for [Squeak](http://www.squeak.org).

- [**CheckbooX**](CheckbooX/), a Mac OS X application that mimics the
  register included with your checkbook.

- [**TwICE**](http://twice.sourceforge.net/), a Java implementation of the
  [Information and Content Exchange (ICE)](http://www.w3.org/TR/NOTE-ice)
  v1.1 specification. The latest version implements the new ICE v2.0
  specification. _TwICE is now maintained by
  [Jim Armstrong](mailto:j_armstrong@users.sourceforge.net)._

- [**Rice**](http://rice.sourceforge.net/), a Ruby implementation of the ICE
  v1.1 specification.

- A [**Ruby talk**](writing/rubytalk/index.html) given to the New York City
  CTO Club on July 10, 2001 (HTML and PDF available). (This talk has moved
  to my [Writings](writing.html) page.)

- [**RuBoids**](ruboids/index.html), a Ruby Boids simulation using Qt and
  OpenGL.

## Miscellaneous

My [Ruby Quiz Answers](/rubyquiz/).

## Defunct Projects

- [**KeyMaster**](keymaster/index.html) (see
  [**PatchMaster**](https://github.com/jimm/patchmaster))

- [**MIDI Through**](MIDI_Through.html)

- [**NQXML**](http://nqxml.sourceforge.net/), a pure-Ruby XML parser. The
  project page still exists and the code is still available, but since Ruby
  now ships with [REXML](http://www.germane-software.com/software/rexml/),
  NQXML has become much less desirable.

- [**DelimParser.rb**](DelimParser.rb), a Ruby class that parses
  character-delimited data files such as .CSV and tab-delimited text files.
  It handles different delimiters and quote marks as well as delimiters,
  escaped characters, and doubled quotes that appear in the data. Since Ruby
  now ships with the `csv` module, DelimParser has become irrelevant.
