---
layout: default
---

# Ruby Quiz 60

Here is my solution to Ruby Quiz 60:
[Numeric Maze](http://www.rubyquiz.com/quiz60.html). The challenge is to
find the shortest path from one number to another by applying three
operations (double, halve, add_two).

My approach uses recursion to perform a breadth-first search. At first, I
used pruning cyclic paths to speed up longer solutions: running `solve(22,
999)` dropped from over seven minutes to under 20 seconds (667 MHz PPC, Mac
OS X). Next, I tried avoiding calling double after half, and vice versa.
That saved even more time and actually removed the need for the cyclic path
check, since give that optimization cycles can't happen.

I also tried pruning longer lists (those where the last number appeared
earlier in another path), but doing that didn't save time, probably because
my algorithm was `O(n<sup>2</sup>)`.

I use `send(symbol, <var>n</var>)` to call the operations. I tried using
`Proc` objects and `Proc.call`, but it ended up being between 33% and 50%
slower.

- [numeric_maze.rb](numeric_maze.rb)
- [numeric_maze_test.rb](numeric_maze_test.rb)

Back to my [Ruby Quiz solutions page](../).
