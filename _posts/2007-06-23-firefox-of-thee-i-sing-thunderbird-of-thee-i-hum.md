---
layout: post
title: Firefox - Of Thee I Sing; Thunderbird - Of Thee I Hum
tags: edit, firefox, opensource, text
---

_or: Don't Fence Me In --- or: Freedom, by George Michaels_

I've tried the new [Safari Beta 3](http://www.apple.com/safari/). It's
really fast and refreshingly standards-compliant. I don't care for the
brushed aluminum look, though supposedly that's going away.

There's no way I'll switch from [Firefox](http://www.mozilla.com/firefox/),
though. There are two main reasons: I rely on many useful Firefox
extensions, and Firefox is still more cross-platform than Safari. Firefox
also supports more search engines in its search text field. To be fair and
balanced, I must point out that Firefox 2.X crashes or hangs on Mac OS X all
the time. I put up with that because of all the other benefits.

That first reason is the biggest though. Firefox is more hackable, which
makes it more useful. Here is the list of Firefox extensions I use. The
[Firefox Add-ons](https://addons.mozilla.org/firefox/) page is also a great
resource.

- [Google Browser Synch](http://www.google.com/tools/firefox/browsersync/index.html)
- [Adblock](http://adblock.mozdev.org/)
- [Firebug](http://www.getfirebug.com/) for Web development
- [Web Developer](http://chrispederick.com/work/web-developer/)
- [LiveHttpHeaders](http://livehttpheaders.mozdev.org/)
- [Long Titles](http://home.etu.unige.ch/~robin0/LongTitles_en.html)
- [del.icio.us](http://del.icio.us/help/firefox/extension)
- [It's All Text!](https://addons.mozilla.org/firefox/4125/)
- [ViewSourceWith](http://dafizilla.sourceforge.net/viewsourcewith/)
- [Nagios Checker](http://code.google.com/p/nagioschecker/)
- [Conkeror](http://conkeror.mozdev.org/) Emacs key bindings. FF 1.5+

"It's All Text!" lets you edit any textarea's text using your favorite
editor. Mine's set to use Emacs, of course. You can set the editor in the
preference dialog box, but it might be easier for you to edit the Firefox's
user prefs Javascript file and add

{% highlight javascript %}
  user_pref("extensions.itsalltext.editor",
            "/Applications/Emacs.app/Contents/MacOS/Emacs");
{% endhighlight %}

I should probably use `emacsclient` instead so the file is open in the
currently running Emacs instead of in a new instance.

Switching to another browser like Safari would force me to give up too many
extensions that I have come to rely on. Google Browser Synch is probably the
most useful to me, with Firebug and LiveHttpHeaders coming in a close second
and third.

Safari does have some features that Firefox doesn't, of course. Sharing your
bookmarks with those around you via Bonjour and integration with Apple's
AddressBook are the two I can think of. I don't want either. How often have
I wanted to share all my bookmarks with others or see all of theirs? Never.
Hell, I password-protect my Firefox so that if other people use it they
won't see the form field values that Firefox saves for me.

There are some little things that bug me about Safari, too. For example, the
keyboard shortcut to open/close the bookmarks sidebar is Option-Command-B
and the command to switch to the Google search text field is
Option-Command-F. I hate the Option-Command combo; it forces me to switch my
whole left hand position away from the home row. In Firefox it's Command-B
and Command-K for Mac OS X, Control-B and Control-K for Windows and Linux.

For similar reasons, I use Thunderbird instead of Apple's Mail. Not because
of the extensions (I only use one: [Enigmail](http://enigmail.mozdev.org/)),
but because it is cross-platform, uses a standard format for email message
storage, and uses an open format for its address book. I'm using Mac OS X
now, but it's possible that I might want to switch to Linux (Ubuntu is quite
nice) or be forced to switch to Windows at some point. I can use Thunderbird
on those platforms, too.

When I must open Word documents, Excel spreadsheets, and PowerPoint
presentations I use
[NeoOffice](http://www.neooffice.org/neojava/en/index.php). On Windows, I
use [OpenOffice.org](http://www.openoffice.org/).

It's most important to me that my data is portable not only between
operating systems but also between computers and applications. I refuse to
get locked down into any proprietary format or have my data locked down on
only one computer. I'm letting Google store my (encrypted) browser
information, but I have my own copies of the data on more than one computer,
inside Firefox itself.
