---
layout: post
title: An Erlang MIDI File Reader/Writer
tags: erlang, programming, midi
---

I've been learning [Erlang](http://www.erlang.org/). (See
[Learning a New Programming Language](../../..//2007/05/22/learning-new-programming-language.html).)
As part of that process, I've written three programs so far: a
[Boids](http://en.wikipedia.org/wiki/Boids) flock simulation, a simple Web
application using Erlyweb, and a MIDI file reader/writer.

One point that I might not have made clearly in my previous post is the
reasons that I learn a new language: to learn new ways to think about and
solve coding problems, to see what's out there that's better than what I'm
using (I try not to be a
[Blub programmer](http://www.paulgraham.com/avg.html)), to keep my brain
sharp, and because it's fun.

Coding the MIDI file library helped me learn about Erlang's file I/O, the
binary data type, and a bit more about pattern matching. (The Boids
simulation has much more pattern matching goodness; more about that in
another post.) The code isn't distributed, nor does it really take advantage
of many of Erlang's strengths such as distributed process (Boids does). It
does make use of the binary data type and pattern matching quite heavily.

I was also forced to think about data representation in Erlang: how would I
represent a sequence, a track, and a single MIDI event? I'm not convinced
that I have come up with the best representations, because I have not yet
had the time to use this library for any MIDI file manipulation. When I get
to that point, I fully expect that the data representation will change.

Having written this code in a few different languages before, I knew where
to start: with the easy stuff! I first defined the constants.
`midi_consts.hrl` contains all of the define statements for all the
constants I might need. It was while creating this file that I learned how
to write hex numbers in Erlang. (That sounds like a small, silly thing but I
was quite annoyed for a few minutes before I figure out how to do that.)

{% highlight erlang %}
% Channel messages
-define(STATUS_NIBBLE_OFF, 16#8).
-define(STATUS_NIBBLE_ON, 16#9).
% ...
% System common messages
-define(STATUS_SYSEX, 16#F0).
-define(STATUS_SONG_POINTER, 16#F2).
% ...
{% endhighlight %}

Next, I dove into reading a MIDI file. Since I only deal with MIDI type 1
files which contain multiple tracks in a single file, that's all I bothered
writing. I knew I'd have to read the header and one or more tracks. Erlang
code tends to use atoms, tuples, lists, and records to represent many types
of data, so I came up with a proposed data format for my sequence data. From
the comment for `midifile:read/1`, which takes the path to a MIDI file and
returns a seq tuple:

{% highlight erlang %}
%% Returns
%%   {seq, {header...}, ListOfTracks}
%% header is {header, Format, Division}
%% each track is
%%   {track, ListOfEvents}
%% each event is
%%   {event_name, DeltaTime, [values...]}
%% where values after DeltaTime are specific to each event type.
%% If the value is a string, then the string appears instead of
%% [values...].
{% endhighlight %}

After writing some code that read one byte at a time, I went back to the
"Programming with Files" chapter in
[Programming Erlang](http://books.pragprog.com/titles/jaerlang/) by Joe
Armstrong and realized that I could slurp all of the MIDI data into memory
and randomly access it. This made my code cleaner and faster. It also made
pattern matching much easier, because I could write `midifile:read_event`
with many different pattern-matched arguments but the same arity. Here's the
code that reads an event list within a track:

{% highlight erlang %}
event_list(_F, _FilePos, 0) ->
    [];
event_list(F, FilePos, BytesToRead) ->
    [DeltaTime, VarLenBytesUsed] = read_var_len(file:pread(F, FilePos, 4)),
    {ok, ThreeBytes} = file:pread(F, FilePos+VarLenBytesUsed, 3),
    ?DPRINT("reading event, FilePos = ~p, BytesToRead = ~p, ThreeBytes = ~p~n",
     [FilePos, BytesToRead, ThreeBytes]),
    [Event, EventBytesRead] =
 read_event(F, FilePos+VarLenBytesUsed, DeltaTime, ThreeBytes),
    BytesRead = VarLenBytesUsed + EventBytesRead,
    [Event | event_list(F, FilePos + BytesRead, BytesToRead - BytesRead)].
{% endhighlight %}

Let's start at the end: `event_list/3` is recursive. It builds the list of
events by reading a single event, then calling itself with the remaining
bytes to read in the track. If the remaning number of bytes is 0, the first
clause (the first two lines above) matches and an empty list is returned.
The second, longer clause starts by reading a variable length integer (more
about that below). It then reads the next three bytes of the file (again,
randomly accessing an in-memory copy of the file). Why three bytes? Because
most MIDI events are two or three bytes long. If I need fewer bytes, no harm
done. If I need more, I read more. Those three bytes are passed on to
`read_event/4`, which is a function that is made up of a really long series
of clauses, each of which matches a different MIDI event.

Here are the first few `read_event/4` clauses. The first three arguments are
the file, current file position, and delta time of the event. These clauses
all return an array consisting of the event tuple and the number of bytes
used by the event (excepting the length of the delta time).

{% highlight erlang %}
read_event(_F, _FilePos, DeltaTime,
    <<?STATUS_NIBBLE_OFF:4, Chan:4, Note:8, Vel:8>>) ->
    ?DPRINT("off~n", []),
    put(status, ?STATUS_NIBBLE_OFF),
    put(chan, Chan),
    [{off, DeltaTime, [Chan, Note, Vel]}, 3];
% note on, velocity 0 is a note off
read_event(_F, _FilePos, DeltaTime,
    <<?STATUS_NIBBLE_ON:4, Chan:4, Note:8, 0:8>>) ->
    ?DPRINT("off (using on vel 0)~n", []),
    put(status, ?STATUS_NIBBLE_ON),
    put(chan, Chan),
    [{off, DeltaTime, [Chan, Note, 64]}, 3];
read_event(_F, _FilePos, DeltaTime,
    <<?STATUS_NIBBLE_ON:4, Chan:4, Note:8, Vel:8>>) ->
    ?DPRINT("on~n", []),
    put(status, ?STATUS_NIBBLE_ON),
    put(chan, Chan),
    [{on, DeltaTime, [Chan, Note, Vel]}, 3];
read_event(_F, _FilePos, DeltaTime,
    <<?STATUS_NIBBLE_POLY_PRESS:4, Chan:4, Note:8, Amount:8>>) ->
    ?DPRINT("poly press~n", []),
    put(status, ?STATUS_NIBBLE_POLY_PRESS),
    put(chan, Chan),
    [{poly_press, DeltaTime, [Chan, Note, Amount]}, 3];
read_event(_F, _FilePos, DeltaTime,
    <<?STATUS_NIBBLE_CONTROLLER:4, Chan:4, Controller:8, Value:8>>) ->
    ?DPRINT("controller ch ~p, ctrl ~p, val ~p~n", [Chan, Controller, Value]),
    put(status, ?STATUS_NIBBLE_CONTROLLER),
    put(chan, Chan),
    [{controller, DeltaTime, [Chan, Controller, Value]}, 3]; %
{% endhighlight %}

The `put` calls store the status and channel in the process dictionary, one
of the few places in Erlang that you can modify values. To handle running
status bytes, we need to remember the status and channel. I picked the
process dictionary as the place to store that.

/Added 2007-05-23:/ "Running status bytes" are a way to reduce the size of
MIDI files. If the status byte is the same as the previous status byte, you
can omit it. Also, as a special case a note-on value with a velocity of zero
is considered to be a note-off message. I needed code that would recognize
that the next byte was not a status byte, and use the previous status byte.
I made that an additional `read_event/4` clause, like this:

{% highlight erlang %}
% Handle running status bytes
read_event(F, FilePos, DeltaTime, <<B0:8, B1:8, _:8>>) when B0 < 128 ->
    Status = get(status),
    Chan = get(chan),
    ?DPRINT("running status byte, status = ~p, chan = ~p~n", [Status, Chan]),
    [Event, NumBytes] =
 read_event(F, FilePos, DeltaTime, <<Status:4, Chan:4, B0:8, B1:8>>),
    [Event, NumBytes - 1]; %
{% endhighlight %}

We read the status and channel from the process dictionary and pass them
back to `read_event/4`, which will use Erlang's pattern matching to go back
and find the proper code for that status byte. <em>End of additions.</em>

?DPRINT is a macro that I defined to output when DEBUG is defined and do
nothing when it isn't:

{% highlight erlang %}
% -define(DEBUG, true).
-ifdef(DEBUG).
-define(DPRINT(X, Y), io:format(X, Y)).
-else.
-define(DPRINT(X, Y), void).
-endif. %
{% endhighlight %}

MIDI encodes certain multi-byte integer values by "variable length encoding"
it: splitting it into seven bit chunks and outputting them with the
highest-order chunk first. The last, lowest-bit chunk has the high bit set
to zero, the earlier, higher chunks have the high bit set to one. Thus zero
is encoded as `00000000` and 129 is encoded as `10000001 00000001`. Notice
that the code in `event_list/1` always reads the next four bytes; that's
because the MIDI spec guarantees that var length numbers are at most four
bytes long. Here's the code for `read_var_len/1`, which returns a list
containing the value and the number of bytes it uses:

{% highlight erlang %}
read_var_len({ok, <<0:1, B0:7, _:24>>}) ->
    [B0, 1];
read_var_len({ok, <<1:1, B0:7, 0:1, B1:7, _:16>>}) ->
    [(B0 bsl 7) + B1, 2];
read_var_len({ok, <<1:1, B0:7, 1:1, B1:7, 0:1, B2:7, _:8>>}) ->
    [(B0 bsl 14) + (B1 bsl 7) + B2, 3];
read_var_len({ok, <<1:1, B0:7, 1:1, B1:7, 1:1, B2:7, 0:1, B3:7>>}) ->
    [(B0 bsl 21) + (B1 bsl 14) + (B2 bsl 7) + B3, 4];
read_var_len({ok, <<1:1, B0:7, 1:1, B1:7, 1:1, B2:7, 1:1, B3:7>>}) ->
    ?DPRINT("WARNING: bad var len format; all 4 bytes have high bit set~n", []),
    [(B0 bsl 21) + (B1 bsl 14) + (B2 bsl 7) + B3, 4].
{% endhighlight %}

`bsl` means "bit-shift left".

Only after finishing the MIDI file reader code did I attack the MIDI file
writer. For that, I created an in-memory "IO list". An IO list is a list
that consts of other IO lists, binaries, or bytes (integers between 0 and
155). The Erlang library method `file:write_file/2` writes an IO list with
one call.

Here is the code that writes a MIDI var len value:

{% highlight erlang %}
var_len(I) when I < (1 bsl 7) ->
    <<0:1, I:7>>;
var_len(I) when I < (1 bsl 14) ->
    <<1:1, (I bsr 7):7, 0:1, I:7>>;
var_len(I) when I < (1 bsl 21) ->
    <<1:1, (I bsr 14):7, 1:1, (I bsr 7):7, 0:1, I:7>>;
var_len(I) when I < (1 bsl 28) ->
    <<1:1, (I bsr 21):7, 1:1, (I bsr 14):7, 1:1, (I bsr 7):7, 0:1, I:7>>;
var_len(I) ->
    exit("Value " ++ I ++ " is too big for a variable length number").
{% endhighlight %}

This code makes use of guard clauses: expressions that determine whether or
not to execute a function clause. Note that the final clause exits. This
matches Erlang's philosophy that you should code for the normal case and let
errors happen. It might have been more in the Erlang style to leave off the
last case entirely, and let the program fail with a "bad match". Perhaps
I'll remove it.

After finishing the writer, I read in a file with the reader and output the
Erlang representation using the writer. The result: a few differences, but
all due to decisions about running status byte values. The code isn't
perfect; it has a long way to go. I've learned a lot, though.

Next: a Boids simulation in Erlang.
