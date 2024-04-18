---
layout: post
title:  "Emacs and Rails Testing"
tags: emacs testing programming ruby rails
---

I'm an inveterate Emacs user. It's been my Swiss Army chainsaw of choice for
over 33 years. Part of the beauty of Emacs is that it's extensible and
configurable. The relatively new[^1] package manager and ELPA package
archive are a great start, but sometimes it's better --- or simply more fun
--- to roll your own.

> This post was originally published
> on [The Dirty Birds](http://dirtybirds.chloeandisabel.com/), the Chloe +
> Isabel tech team blog.

I've developed a few Emacs Lisp functions that let me run our Rails
[RSpec](http://rspec.info/) tests at varying levels of granularity and
within various environments.

Granularity: _what_ to test.

- Run all tests in a directory and its subdirectories.
- Run all tests in a single file, by default the one that's in the current
  buffer.
- Run a single test or single context within a spec file.

Environment: _where_ to run the test.

- Within an Emacs
  [compilation buffer](http://www.gnu.org/software/emacs/manual/html_node/emacs/Compilation-Mode.html),
  which has features like jumping right to the source code referenced in any
  error message output can be used to jump directly to the relevant line of
  code.
- Within a shell running in an external terminal program such as the Mac OS
  X Terminal program or [iTerm 2](https://www.iterm2.com/). Running within a
  shell instead of using compilation mode is necessary when you need to
  interact with the tests, for example if you insert a
  [Byebug](https://github.com/deivid-rodriguez/byebug) breakpoint in the
  code. To send text to these external programs, we'll use AppleScript.
- Within a shell running inside Emacs. This is left as an exercise for the
  reader.

Many of the code samples here come from my Emacs init files, which are
available on Github at [jimm/elisp](https://github.com/jimm/elisp). The bulk
of this code can be found in
[ruby-testing.el](https://github.com/jimm/elisp/blob/master/progmodes/ruby-testing.el)
and
[my-rails.el](https://github.com/jimm/elisp/blob/master/progmodes/my-rails.el).

### The Command

The first thing we need is the command we want to run. Variables that we
will fill in `<LOOK_LIKE_THIS>`.

{% highlight bash %}
cd <RAILS_ROOT> && \
    echo > log/test.log && \
    RAILS_ENV=test bundle exec rspec --seed=<SEED> <RPEC_PATH_AND_LINE>...
{% endhighlight %}

The first line takes us to the root of the Rails project.

The second line empties out the log file without deleting it. If you move or
delete a log file that Rails has open it won't recreate a new one, so
instead you can zero out the existing file by doing this. The third line
runs the test.

The command to run the tests needs to specify a random seed and one or more
paths and optionally lines within files. The random seed is used by RSpec to
determine in what order tests are run. By default, we'll use the value
`$RANDOM` which is a magic variable defined by most Unix shells that returns
a different value every time it is read. If a test fails sometimes but not
others, that could be because the order of the tests matters to the outcome.
(If that is the case, it's a sign that the test needs to be rewritten so
that it has no external or intra-test data dependencies.) In that case you
may want to make sure you use the same random seed while debugging so that
the tests are run in the same order.

`RSPEC_PATH_AND_LINE` can be a directory (`$RAILS_ROOT/spec/models`), file
(`$RAILS_ROOT/spec/models/foo.rb`), or file plus line number
(`$RAILS_ROOT/spec/models/foo.rb:42`). If a line number is specified, then
the test(s) containing that line is run. The line number doesn't have to be
the first line of the test; any line in the test will do. Additionally, if
the line number is outside of any single test but within a `context` or
`describe` block, then all tests in that block will be run.

The `rspec` command can actually take multiple dir/file name arguments, but
we're only going to worry about running one right now.

#### Generating the Command

Here's the elisp[^2] code that generates the command. The function
`my-rails--rspec-command` takes a seed value and a file name (or directory
name or file-plus-line-number) and returns a string containing the command
we want. It calls `find-rails-root` to search for the Rails root directory
at or above the specified file's directory. The two dashes in the function's
name are a convention that tells the reader that this is a locally-used
internal function not intended for export or use by other code.

{% highlight emacs-lisp %}
(defun my-rails--rspec-command (seed fname)
  (let* ((rails-root (find-rails-root (file-name-directory fname)))
         (rspec-cmd (if (file-exists-p (concat rails-root "bin/rspec"))
                        "bin/rspec"
                      "rspec")))
    (concat "cd " rails-root " && "
            "echo > log/test.log && "
            "RAILS_ENV=test bundle exec " rspec-cmd " "
            (my-rails--seed-arg-string seed) " " fname)))
{% endhighlight %}

The function that finds the Rails root directory at or above a file's
directory is `find-rails-root`. It uses the predicate function
`rails-root-p` to determine if a directory is a Rails root directory. By
long-standing Lisp convention, the names of predicate functions (those that
return true or false) end with `-p`, like Ruby's convention of using `?`.

{% highlight emacs-lisp %}
(defun rails-root-p (path)
  "Returns true if path is a Rails root directory. Uses a heuristic that
involves looking for known Rails directories."
  (and path
       (file-directory-p path)
       (file-exists-p (concat path "Rakefile"))
       (file-directory-p (concat path "app"))
       (file-directory-p (concat path "config"))
       (file-directory-p (concat path "lib"))
       (file-directory-p (concat path "public"))))

(defun find-rails-root (path)
  "Returns Rails root dir at or above PATH. Returns nil if PATH is nil or no
Rails root dir is found. Uses `rails-root-p'."
  (locate-dominating-file path #'rails-root-p))
{% endhighlight %}

The seed option for the command is generated by this function:

{% highlight emacs-lisp %}
(defun my-rails--seed-arg-string (seed)
  "Returns \"--seed=SEED\". If SEED is 1, returns \"--seed=$RANDOM\"."
  (concat "--seed="
          (if (equal seed 1) "$RANDOM" (int-to-string seed))))
{% endhighlight %}

One more addition lets us run the test(s) that are at point[^3]:

{% highlight emacs-lisp %}
(defun my-rails--rspec-at-point-command (seed fname &optional line-num)
  (concat (my-rails--rspec-command seed fname)
          ":" (int-to-string (line-number-at-pos))))
{% endhighlight %}

### Actually Running the Tests

Now that we can build the command we need, it's simple to write functions
that run the command for the current line, current file, or an entire
directory.

There are two "environments" (a compilation buffer within emacs or an
external terminal program) and really only two granularities (whatever is at
point or a file/directory). We can abstract those options a bit by passing
around functions. One pair of functions takes a command string and executes
it in the proper environment. For those we use `#'compile` and
`#'send-to-iterm`. The former function is built in to Emacs and the latter
is defined below.

We could theoretically create another pair that determine granularity by
returning the proper final argument for the command string, but when I
starting thinking about doing that it seemed to me that the code would
become unnecessarily obtuse.

{% highlight emacs-lisp %}
(defun run-spec-using (run-func seed fname)
  "Run RSpec test FNAME from the rails root directory above it.
If SEED is 1, $RANDOM will be used. Calls
`my-rails--rspec-command' to generated the command to run.
RUN-FUNC must be a function such as `compile' that takes a string
and executes it."
  (funcall run-func (my-rails--rspec-command seed fname)))

(defun run-spec (seed fname)
  "Run RSpec test FNAME from the Rails root directory above it.
If SEED is 1, $RANDOM will be used. FNAME may contain extra line
number info (e.g., 'foo.rb::42')."
  (interactive "p\nF") ; possibly nonexistent file name so we can append ":NNN"
  (run-spec-using #'compile seed fname))

(defun run-spec-in-iterm (seed fname)
  "Run RSpec test at point in iTerm. If SEED is 1, $RANDOM will
be used."
  (interactive "p\nF") ; possibly nonexistent file name so we can append ":NNN"
  (run-spec-using #'send-to-iterm seed fname))


(defun run-spec-at-point-using (func seed)
  "Run RSpec test FNAME from the rails root directory above it.
If SEED is 1, $RANDOM will be used. Calls
`my-rails--rspec-at-point-command' to generated the command to run.
RUN-FUNC must be a function such as `compile' that takes a string
and executes it."
  (funcall func (my-rails--rspec-at-point-command
                 seed
                 (buffer-file-name)
                 (line-number-at-pos))))

(defun run-spec-at-point (seed)
  "Run RSpec test at point from the Rails root directory. If SEED is 1,
$RANDOM will be used."
  (interactive "p")
  (run-spec-at-point-using #'compile seed))

(defun run-spec-at-point-in-iterm (seed)
  "Run RSpec test at point in iTerm. If SEED is 1, $RANDOM will
be used."
  (interactive "p")
  (run-spec-at-point-using #'send-to-iterm seed))
{% endhighlight %}

`interactive` is a special form[^4] that tells the function what types the
args are and how to retrieve or prompt for them. Since the seed argument for
all of these functions is numeric and since I usually want to use the
default value, we tell the functions to use their
[_numeric_ or _prefix argument_](http://www.gnu.org/software/emacs/manual/html_node/emacs/Arguments.html)
for the seed parameter.

The final missing piece is `send-to-iterm`:

{% highlight emacs-lisp %}
(defun send-to-iterm (str)
  "Send STR to the front window/session in iTerm. STR may contain
multiple lines separated by `\n'."
  (interactive "siTerm input: ")
  (let ((lines (split-string
                (replace-regexp-in-string "\"" "\\\"" str t t)
                "\n")))
    (do-applescript (concat
                     "tell application \"iTerm\"\n"
                     "	tell the current terminal\n"
                     "    tell the current session\n"
                     (mapconcat (lambda (s) (concat "write text \"" s "\"\n")) lines "")
                     "    end tell\n"
                     "	end tell\n"
                     "end tell\n"
                     ))))
{% endhighlight %}

Writing this article caused me to review the code and improve it by
refactoring it a bit. I even found a glaring error in the design: I assumed
that the "current line" was to be found by asking the current buffer, even
when calling a function with a completely different file.

### Further Reading

I'm writing the book
[Emacs Mastery: Attaining Coding Supremacy](https://leanpub.com/emacs-mastery),
and hope to be finished later this year. (Writing a book takes a long time.
Who knew?) In the mean time, enjoy
[Mastering Emacs](https://www.masteringemacs.org/) by Mickey Petersen.

----

[^1]: Of course, with an editor that's around forty years old almost
    everything is relatively new.

[^2]: That's cool-kid shorthand for Emacs Lisp.

[^3]: "Point" is Emacs-speak for the location of the cursor in a buffer.

[^4]: _i.e._, magic.
