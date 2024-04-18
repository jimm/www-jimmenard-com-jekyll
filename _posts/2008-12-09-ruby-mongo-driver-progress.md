---
layout: post
title: Ruby Mongo Driver Progress
tags: 10gen database mongo ruby programming clojure cloud
---

Over the last few days I've added a few features to the
[Ruby Mongo driver](https://github.com/jimm/mongo-ruby-driver/tree/master):

- Sorting
- Read/write support for arrays and regular expressions
- An ObjectID class and read/write support
- More tests

Database commands are JSON objects (sort of) which are <em>almost</em> like
Ruby hashes, but not quite. Their keys are ordered, so I whipped up an
OrderedHash class to use when the driver sends commands to Mongo. Adrian
Madrid ([aemadrid@gmail.com](mailto:aemadrid@gmail.com)) has been helping
out a lot by providing invaluable feedback, tests, suggestions, and fixes.
