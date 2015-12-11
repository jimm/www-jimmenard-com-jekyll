---
layout: default
---

# Ruby Quiz 35

Here is my solution to Ruby Quiz 35:
[Chess Variants (I)](http://www.rubyquiz.com/quiz35.html). My solution
depends upon [Bangkok](http://bangkok.rubyforge.org), my
chess-game-replaying library.

To use this solution, you need to install Bangkok (which in turn requires
midilib) as well as the following files:

- [board.rb](board.rb)
- [chessgame.rb](chessgame.rb)
- [displaylistener.rb](displaylistener.rb)
- [main.rb](main.rb)

Alternately, you can download [playchess.tar.gz](playchess.tar.gz), which
contains the directory "playchess" that holds all four files.

```
% gem install bangkok
...
% copy_these_files_to_your_machine
% cd playchess
% main.rb
[board is drawn]
White: f4
[board is drawn]
Black: Nf6
...
```

<p>Back to my [Ruby Quiz solutions page](../).</p>
