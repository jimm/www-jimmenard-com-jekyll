---
layout: post
title: Erlang Fractal Benchmark
tags: erlang, programming
---

While looking at a simple
[fractal benchmark](http://www.timestretch.com/FractalBenchmark.html) that
showed up on the [programming Reddit](http://programming.reddit.com), I
noticed that there wasn't an [Erlang](http://www.erlang.org/) version. Below
is one I wrote last night. Erlang fares rather well. One thing mildly
surprised me: it runs _slightly_ faster in an Erlang shell within Emacs than
in both Apple's Terminal and iTerm on Mac OS X. Within Emacs it runs in
1.09000 (runtime) 1.14100 (wall clock) seconds. In both Terminal and iTerm
it runs in around 1.11000 (runtime) 1.16600 (wall clock) seconds. Perhaps
screen I/O isn't as fast in the terminal programs.Two caveats: first, these
numbers were generated on my 2.33 GHz Intel MacBook Pro; I don't know what
the original benchmarks used. Also, I only ran the code a handful of times
and picked a "typical" time to report. A better test would have been to run
the code hundreds or thousands of times and average the values.This post
also says a bit about intuition vs. measuring. I discuss some code
modifications and their expected and actual effects below.Another thing to
note: the author of the fractal benchmark page says that he hasn't bothered
to optimize the code for each language he tested. I don't know if using
`lists:map/2` or extracting `iter_value/5` and using guard clauses would
disqualify this version in his opinion.

{% highlight erlang %}
-module(fractal_benchmark).
-author("Jim Menard, jimm@io.com").
-export([run/0]).

-define(BAILOUT, 16).
-define(MAX_ITERATIONS, 1000).

%% Idea from http://www.timestretch.com/FractalBenchmark.html

run() ->
    io:format("Rendering~n"),
    statistics(runtime),
    statistics(wall_clock),
    lists:map(fun(Y) ->
                      io:format("~n"),
                      lists:map(fun(X) -> plot(X, Y) end, lists:seq(-39, 39))
              end,
              lists:seq(-39, 39)),
    io:format("~n"),
    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    Sec1 = Time1 / 1000.0,
    Sec2 = Time2 / 1000.0,
    io:format("Erlang Elapsed ~p (runtime) ~p (wall clock) seconds~n",
              [Sec1, Sec2]).

plot(X, Y) ->
    case iterate(X/40.0, Y/40.0) of
        0 ->
            io:format("*");
        _ ->
            io:format(" ")
    end.

iterate(X, Y) ->
    CR = Y - 0.5,
    CI = X,
    iter_value(CR, CI, 0.0, 0.0, 0).

iter_value(_, _, _, _, I) when I > ?MAX_ITERATIONS ->
    0;
iter_value(_, _, ZI, ZR, I) when ZI * ZI + ZR * ZR > ?BAILOUT ->
    I;
iter_value(CR, CI, ZI, ZR, I) ->
    Temp = ZR * ZI,
    ZR2 = ZR * ZR,
    ZI2 = ZI * ZI,
    ZRnew = ZR2 - ZI2 + CR,
    ZInew = Temp + Temp + CI,
    iter_value(CR, CI, ZInew, ZRnew, I + 1). %
{% endhighlight %}

You might have noticed that `ZI * ZI` and `ZR * ZR` are calculated twice:
once in the body of the last clause and once in the second guard clause. The
guard clause has to be executed every time, which means that running the
last, most frequently executed clause executes the multiplications twice. I
tried pre-calculating those values and adding them as parameters, so the arg
list is

{% highlight erlang %}
iter_value(_CR, _CI, _ZI, _ZI2, _ZR, _ZR2, I)
{% endhighlight %}

Did it help? It did indeed. Execution time in Emacs went down to 0.890000
(runtime) 0.919000 (wall clock) seconds. Here are the modified versions of
`iterate` and `iter_value`:

{% highlight erlang %}
iterate(X, Y) ->
    CR = Y - 0.5,
    CI = X,
    iter_value(CR, CI, 0.0, 0.0, 0.0, 0.0, 0).

iter_value(_, _, _, _, _, _, I) when I > ?MAX_ITERATIONS ->
    0;
iter_value(_, _, _, ZI2, _, ZR2, I) when ZI2 + ZR2 > ?BAILOUT ->
    I;
iter_value(CR, CI, ZI, ZI2, ZR, ZR2, I) ->
    Temp = ZR * ZI,
    ZRnew = ZR2 - ZI2 + CR,
    ZInew = Temp + Temp + CI,
    iter_value(CR, CI, ZInew, ZInew * ZInew, ZRnew, ZRnew * ZRnew, I + 1).
{% endhighlight %}

One final thing I tried was commenting out the calls to `io:format`. In my
experience, screen I/O usually slows things down quite a bit. (In the case
statement in `plot/2`, I had to replace them with `void` statements instead
of simply commenting them out.) The result: execution time went down to
0.830000 (runtime) 0.839000 (wall clock) seconds within Emacs. In iTerm,
execution time was only slightly slower than that. So the time decreased,
but not nearly as much as it did when I removed the extra multiplications.
I'm surprised. Is multiplication that expensive in Erlang, or is I/O well
optimized, or was my instinct wrong? Come to think of it, `io:format` is
only called once per coordinate; the multiplications happen thousands of
times for each.A distributed version of this algorithm is certainly possible
(say, one process for every X,Y coordinate). My gut tells me that it would
run slower because the calculation for an individual coordinate is
relatively small and the message passing overhead and gathering and
coordination of the results would outweigh the benefits. My intuition was
wrong about the effects of I/O, though. I'd have to try it to make sure.
**Additions:** In the comments, Ulf Wiger suggested that I add `is_float`
guards for all the function parameters that are floats. Doing this to
`iter_value/7` reduced execution time by almost half to 0.450000 (runtime)
0.455000 (wall clock) seconds, a huge savings. (Does anybody know why adding
these guard clauses speeds up execution? I would imaging that extra checking
would slow it down.) Here's the new code for `iter_value/7`:

{% highlight erlang %}
iter_value(_CR, _, _ZI, _ZI2, _ZR, _ZR2, I)
  when I > ?MAX_ITERATIONS,
  is_float(_CR), is_float(_ZI), is_float(_ZI2), is_float(_ZR), is_float(_ZR2) ->
    0;
iter_value(_CR, _, _ZI, _ZI2, _ZR, _ZR2, I)
  when _ZI2 + _ZR2 > ?BAILOUT,
  is_float(_CR), is_float(_ZI), is_float(_ZI2), is_float(_ZR), is_float(_ZR2) ->
    I;
iter_value(CR, CI, ZI, ZI2, ZR, ZR2, I)
  when
  is_float(CR), is_float(ZI), is_float(ZI2), is_float(ZR), is_float(ZR2) ->
    Temp = ZR * ZI,
    ZRnew = ZR2 - ZI2 + CR,
    ZInew = Temp + Temp + CI,
    iter_value(CR, CI, ZInew, ZInew * ZInew, ZRnew, ZRnew * ZRnew, I + 1).
{% endhighlight %}

Ulf and others also suggested that I avoid printing each character
separately. Doing so did not seem to change execution time at all. Here's
what I did:

{% highlight erlang %}
% changed the inner map call to plot
run() ->
    % ...
    Seq = lists:seq(-39, 39),
    lists:map(fun(Y) ->
                      CharList = lists:map(fun(X) -> plot(X, Y) end, Seq),
                      io:format("~s~n", [CharList])
              end,
              Seq),
    % ...

% changed plot to return single-character strings
plot(X, Y) ->
    case iterate(X/40.0, Y/40.0) of
        0 ->
            "*";
        _ ->
            " "
    end. %
{% endhighlight %}

I also tried commenting out the `io:format/2` call above. Execution time
went up about 1/100 of a second.
