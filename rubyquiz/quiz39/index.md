---
layout: default
---

# Ruby Quiz 39

Here is my solution to Ruby Quiz 39:
[Sampling](http://www.rubyquiz.com/quiz39.html). This solution, which takes
roughly 1.75 minutes to run realtime (0.010 sec user time) is so short, I
present it here in its entirety:

{% highlight ruby %}
#! /usr/bin/env ruby

require 'set'

def sample(members, range)
  selected = Set.new
  members.times {
    val = rand(range)
    val = rand(range) until selected.add?(val)
  }
  selected.to_a.sort
end

puts sample(ARGV[0].to_i, ARGV[1].to_i).join("\n")
{% endhighlight %}

This solution is completely out-of-the-box. I played with a few
optimizations, without looking for this algorithm anywhere online. Instead
of using a `Set` (which is backed by a `Hash`), I wanted to create a
_`range`_-length array and mark each selected value using that array. With a
range of 10e9, my machine ran out of memory.

Disk I/O took about 45 seconds of the total time. There's probably a way to
speed that up.

Back to my [Ruby Quiz solutions page](../).
