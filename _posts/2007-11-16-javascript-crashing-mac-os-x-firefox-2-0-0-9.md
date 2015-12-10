---
layout: post
title: JavaScript Crashing Mac OS X Firefox 2.0.0.9
tags: osx, firefox, javascript
---

Recently I upgraded to Firefox 2.0.0.9 on Mac OS X. Ever since then, Firefox
has been crashing extremely frequently. Most often, it's when I'm closing a
tab---usually GMail.

When the Apple problem reporter app fires up, I get to see the stack. Every
time I've checked, the crash has been in the JavaScript engine somewhere
(the times I've remembered to check, it's always crashed in libmozjs.dylib).

I just reproduced the problem frighteningly easily: after a crash I
restarted Firefox. I then went to GMail. After the page loaded, I closed the
single tab containing GMail. Crash. Ouch.

What is keeping me from switching to Safari or Opera? At this point,
familiarity and Google's bookmark synchronizer. The synchronizer has its own
problems, though.
