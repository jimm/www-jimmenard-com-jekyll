---
layout: default
---

# Ruby Quiz 49

Here is my solution to Ruby Quiz 49:
[Lisp Game](http://www.rubyquiz.com/quiz49.html). It consists of two parts:
the game engine and a game description. I've called it "RADS" in homage to
the [TADS](http://www.tads.org/) interactive fiction engine. In the quiz
description, James mentioned that you could take at least two approaches:
mimic the Lisp or do it the "Ruby way". I've attempted to do the latter.

- [rads.rb](rads.rb) the engine
- [game.rb](game.rb) the game description and custom verbs

To run this game, download both files and execute game.rb.

## Features

### Game engine

- Accepts inventory or i

- Accepts look or l, also accepts "look at x"

- Accepts examine or x, which prints a long description

- "it" represents the last-examined, taken, or dropped object. You can take
  it, examine it, look at it

- Short direction names (n, s, e, w, u, d)

- Accepts walk or go

- Short direction names are also verbs so you can just type "w" to go
  west

Altername names for things ("whiskey bottle", "bottle", "whiskey")

- Decorations, which are objects that can't be taken. Try "x wizard" or
  "look at couch".

- A decoration without a short_desc won't be output as part of the room's
  description. You can examine the couch, but it won't be described
  separately because it's already part of the wizard's long description.

- Game-specific verbs are defined in the game file, not in the engine

- Any object with no "names" array defined in the initialization proc will
  have one created for it containing the short_desc

- Containment (things within other things) is implemented and contents of
  containers like the bucket will be printed, but "put in"/"take out" is not
  yet implemented.


To do:

- Fix the fact that you can't examine the door in the garden

- Implement "put in"/"take out".

- Write a "put x in y" verb

- Understand prepositions. In addition to "splash bucket [on] wizard" and
  "dunk bucket [in] well", I'd like to allow "splash wizard with
  bucket".</p>

### Game file

- Game-specific verbs are defined here, not as part of the RADS library

- The dunk, weld, and splash verbs take (but ignore) prepositions. Try
  "splash bucket on wizard" or "splash bucket wizard".

Back to my [Ruby Quiz solutions page](../).
