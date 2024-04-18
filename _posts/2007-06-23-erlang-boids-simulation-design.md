---
layout: post
title: Erlang Boids Simulation Design
tags: erlang programming
---

As one of my [Erlang](http://www.erlang.org/) programming exercises, I
decided to write the non-graphical part of a
[Boids](http://www.red3d.com/cwr/boids/) simulation. I've written the same
thing in a few different languages (Java, Ruby, Lisp, C++) before. Using
Erlang would be interesting because of its support for message-based
parallelism and concurrency.

I figured at first that each bird should run in its own process. In each of
my other implementations there is also a flock object. Not necessarily a
big-O Object, but at least some central place where the birds are collected
that can answer questions about them such as the average velocity of the
flock and its center of mass. Even with a multi-process Erlang
implementation, it makes sense to have a flock process. Flocking behavior
rules depend upon each bird's knowledge of the position and velocity of all
other birds in the flock (more realistically, all other birds it can see).
There are two choices: make each bird know about all other birds or have a
flock object that can answer questions about all birds. Making each boid
(bird) aware of all the others seems to be a bad design decision: it
requires O(n^2) communications overhead for every calculation. Each boid has
to ask all the others its position and velocity all the time.

With a flock object, the same communications are O(n) because the flock can
ask each boid for its position and velocity, and then respond with the
aggregate information (average positions, average velocities) when asked.The
number of calculations is still O(n^2) because each boid wants to know the
average position and velocity excluding itself. It's the number of messages
and the number of connections between processes that is O(n). To reduce the
number of calculations to O(n), you could ignore the "excluding itself"
qualification.

My first Erlang implementation resulted in a nasty deadlock. The flock
periodically messaged each boid, telling it to move. When the boid received
the move message, it updated its position and velocity. In order to do that,
it had to message the flock, asking for information about the other boids.
When that happened, the program hung because the flock not only wasn't
listening for messages, it was still waiting for a response from that boid.
Deadlock!

The next version had the flock asking each boid for its location information
first, and then telling each boid to move, pasing in the information it
needed. This worked, but it was synchronous and definitely not elegant.

Finally, I hit upon a better design: The flock would request position
information from each boid periodically, and separately each boid would
peroidically tell itself to move, asking the flock for the other boid's
information when it needed it. There is a chance that a boid could have
moved while other boids were relying upon it's old position and velocity
cached by the flock, but that's not really important. In real life birds
using old, slightly out-of-date information all the time: they blink, or are
distracted by a bug, or are subject to the speed of light's limitations on
information gathering.
