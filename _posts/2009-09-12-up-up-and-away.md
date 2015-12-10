---
layout: post
title: Up, Up, and Away
tags: programming, filesystem, unix, shell
---

Let's say you are in a subdirectory, and there's a Makefile in a parent
directory. How do you run make? You climb back up to the parent directory
and type "make", or use "make -C parent_dir". In either case, you have to
know what the parent dir is. Here are a pair of scripts that do that for
you.

The `findup` script's job is to find a file in a parent directory. It prints
the directory name if found, else it exits with status 1.

{% highlight bash %}
#! /bin/sh
#
# usage: findup file [file...]
#
# Finds any of the files in the current directory or any directory above and
# prints the directory name. If no such directory is found (we hit the root
# directory), exit 1. Note: will not find files in the '/' directory.

start_dir=`pwd`

while [ `pwd` != '/' ] ; do
    for f in $* ; do
        if [ -f $f ] ; then
            echo `pwd`
            exit 0
        fi
    done
    # Keep swimming...keep swimming...swimming, swimming, swimming...
    cd ..
done

# No parent directory
exit 1
{% endhighlight %}

The `makeup` script uses `findup`.

{% highlight sh bash %}
#! /bin/sh
#
# usage: makeup [args...]
#
# Finds the first makefile in the current directory or any directory above and
# then runs make, passing on any args given to this script.
#
# Relies on the "findup" command, which is found in this directory.

mfdir=`findup makefile Makefile`
if [ -z "$mfdir" ] ; then
    echo no makefile found
    exit 1
fi

# We've found a makefile. Use the -C flag to tell make to run from the
# directory where we found the makefile. We do this so that error messages
# produced during the make process are relative to the current directory. I
# think.
make -C $mfdir $*
{% endhighlight %}
