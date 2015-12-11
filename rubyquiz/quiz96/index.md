---
layout: default
---

# Ruby Quiz 96

Here is my solution to Ruby Quiz 96:
[Story Generator](http://www.rubyquiz.com/quiz96.html). I decided to modify
my solution to the [Lisp Game](../quiz49/) quiz so it plays itself. The
output is a random "story" that's all plot and no characterization.

Aside from a small tweak to one method in game.rb, all the "story-telling"
code can be found in rads.rb. Look for the comment "new game-playing methods".
The general approach I took was, for each turn, to find all legal verbs and
construct correct game input. The one tweak to game.rb suppresses error
messages when checking for the legality of certain moves.

The game plays itself to a conclusion in approximately five to ten seconds
on my laptop. If I pipe all output to a file instead of the terminal, it
completes in under a second.

- [rads.rb](rads.rb) the engine, with modified "story-telling"
  code

- [game.rb](game.rb) the game description and custom verbs

To run this game, download both files and execute game.rb. See the notes for
my [original game solution](../quiz49) for details.

Back to my [Ruby Quiz solutions page](../).
