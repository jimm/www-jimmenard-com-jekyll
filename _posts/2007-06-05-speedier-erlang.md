---
layout: post
title: Speedier Erlang
tags: erlang, programming
---

In the comments to
[Erlang Fractal Benchmark](../../../2007/06/04/erlang-fractal-benchmark.html),
Ulf Wiger noted that adding `is_float` guard clauses speeds up the code.

When I asked why on the Erlang email list, Ulf and others explained: when
the compiler sees `is_float(X)` it knows that `X` must be a float. Instead
of worrying about type checks, casting, and other inefficiencies, it can
optimize the code that uses `X`.
