---
layout: default
title: Emacs
---

# Emacs Tips and Tricks

I am an [Emacs](http://www.gnu.org/software/emacs/emacs.html) man. I have
been using Emacs since 1981 or so, and I ain't stopping now. For me, it is
the most productive environment for developing software in almost any
language. I also use Emacs as a personal information manager.

I'm writing
[**Emacs Mastery**: _Attaining Coding Supremacy_](https://leanpub.com/emacs-mastery).
Parts of it come from this page. Please vist the book's Leanpub page, review
the table of contents there, and [let me know](mailto:jim@jimmenard.com)
what else you think the book should cover.

On this page, you will find Emacs tips and tricks that make me more
productive. Over time, I will expand upon the items in the list below and
add more items. I hope you find them useful. These tips are not meant to be
complete; they describe the bare essentials needed to introduce a function
or a concept. To get more help about a function or key combination, use the
techniques found in [Emacs help and info](#help-and-info).

This is not an Emacs tutorial. Emacs comes with a tutorial (`C-h t`)
already.

If you have any questions about any of the entries here, please <a
href="mailto:jim@jimmenard.com">let me know</a>. I'll attempt to answer your
question, and your feedback will help me fix and improve this page.


## Key Bindings

When I describe key bindings, I'll try to use the default bindings.
Sometimes, I will make a mistake because I have redefined a number of keys.
If you see that I've used the wrong key bindings for a function&mdash;or,
indeed, see any errors here&mdash;please
[let me know](mailto:jim@jimmenard.com). I use the standard way of
describing key bindings that is used in the Emacs info program: `C-v` means
control-v (sometimes written ^V), and `M-v` means meta-v, which can be typed
as ESC-v. On many Emacs installations, you can also use some other key as
the meta key such as Alt or Option. After twenty-five years of using the ESC
key, I'm retraining myself to use the Alt key. It seems to reduce strain on
my hands a small bit, but also seems to annoy me occasionally when I want to
do something that takes a Meta-command, then a Control-command. It's also
annoying because I can use Alt for Meta in the Emacs application I use, but
can't in the terminal window because the terminal program uses it already.

# Table of Contents

- [My .emacs file](#my-emacs-file)
- [Emacs help and info](#emacs-help-and-info)
- [The Emacs Wiki](#the-emacs-wiki)
- [ELPA: the Emacs Lisp Package Archive](#elpa-the-emacs-lis-package-archive)
- [Expanding words dynamically](#expanding-words-dynamically)
- [Bookmarks](#bookmarks)
- [abbrev-mode](#abbrev-mode)
- [Binding (function) keys](#binding-function-keys)
- [Snippets](#snippets)
- [Skeletons](#skeletons)
- <span class="disabled"><!-- [ -->Eshell<!-- ](#eshell) --></span>
- [Tags and M-.](#tags-and-m-)
- <span class="disabled"><!-- [ -->Registers<!-- ](#registers) --></span>
- <span class="disabled"><!-- [ -->Compile<!-- ](#compile) --></span>
- <span class="disabled"><!-- [ -->Timed events<!-- ](#timed-events) --></span>
- <span class="disabled"><!-- [ -->Org mode<!-- ](#org-mode) --></span>
- <span class="disabled"><!-- [ -->Encryption<!-- ](#encryption) --></span>
- <span class="disabled"><!-- [ -->Customizing indentation<!-- ](#customizing-indentation) --></span>
- <span class="disabled"><!-- [ -->Calendar<!-- ](#calendar) --></span>
- <span class="disabled"><!-- [ -->Diary<!-- ](#diary) --></span>
- <span class="disabled"><!-- [ -->Time zone, latitude, and longitude<!-- ](#time-zone-latitude-and-longitude) --></span>
- <span class="disabled"><!-- [ -->Font lock mode and colors<!-- ](#font-lock-mode-and-colors) --></span>
- <span class="disabled"><!-- [ -->Hex editor<!-- ](#hex-editor) --></span>

## My .emacs file

You can see all of my Emacs configuration files online. They are checked in
to a [git repository](http://github.com/jimm/elisp/tree/master). The main
initialization file is
[emacs.el](http://github.com/jimm/elisp/tree/master/emacs.el), which is
loaded as part of a machine-specific bootstrap process.

Since I use Emacs on multiple machines, I came up with a customization
scheme that lets me run "before" and "after" code for each machine around my
main initialization code. Each domain (work, home, etc.) gets its own
subdirectory and each machine gets its own subdirectory within the domain.
Inside that are up to four files: dot\_emacs, before.el, after.el, and the
bookmark file emacs.bmk. The file ~/.emacs is a link to the dot_emacs file in
that machine's directory in the proper domain subdirectory.

Here's the .emacs file on the machine I'm using right now, which is really
a link to ~/.emacs.d/elisp/iamplify/mercury/dot_emacs:

~~~ emacs-lisp
;; -*- emacs-lisp -*-
(defvar *my-emacs-lib-dir* "~/.emacs.d/elisp/")
(load-file (concat *my-emacs-lib-dir* "bootstrap-init.el"))
(bootstrap-init "iamplify" "mercury")
~~~

Here's bootstrap-init.el:

~~~ emacs-elisp
;;; *my-emacs-lib-dir* must be defined

(defun bootstrap-file (domain machine file-name)
  (concat *my-emacs-lib-dir* "bootstrap/" domain "/" machine "/" file-name))

(defun load-init-if-exists (domain machine file)
  (let ((f (bootstrap-file domain machine (concat file ".el"))))
    (if (file-exists-p f)
	(load-file f))))

(defun bootstrap-init (domain machine)
  (load-init-if-exists domain machine "before")
  (load-file (concat *my-emacs-lib-dir* "emacs"))
  (load-init-if-exists domain machine "after")
  (setq bookmark-default-file
	(bootstrap-file domain machine "emacs.bmk")))
~~~

So you can see that bootstrap-init runs a "before.el" file, then my main
customization file "emacs.el", then an "after.el" file.

# Emacs help and info

Emacs has extensive online help in the form of the Info program, function
and variable comments, the Help buffer, and apropos.

The <b>Info</b> program (`C-h i`) lets you navigate all of the
documentation for Emacs itself as well as any other programs that come with
Emacs, such as GNU tools and extra Emacs modes not part of the base package.
Help for Info appears at the top of the screen when it first starts.

Emacs is, of course, mostly written in Emacs Lisp. Most of the functions
and variables that are defined in Emacs are self-describing. To see the
<b>documentation for any function</b>, type `C-h f` then enter the
name of the function. For <b>variables</b>, type `C-h v`.
Tab-completion works when entering a name. If you want to see the name of
every function or variable, type tab as the first character.

To find out <b>what a key or key combination does</b>, type `C-h
k`.

To get help about the current <b>buffer's mode</b>, type `C-h
m`. This gives a brief description of the mode and all minor modes and
lists all of the active key bindings.

<b>Apropos</b> (`C-h a`) lets you enter a word or regular
expression, and returns all function names that match along with a brief
description of each.

I map `C-x ?` to `help-for-help`, instead of using
`C-h`. That's because I am used to binding `C-h` (the
backspace key) to `backward-delete-char`. I think the first version
of Emacs I ever used (which wasn't Emacs at all, but Fine (Fine is not Emacs))
used `C-x ?` for `help-for-help`.

# The Emacs Wiki

The [Emacs Wiki](http://www.emacswiki.org/cgi-bin/wiki?EmacsWiki) is _the_
place to go for information about Emacs. The best **starting page** is the
[Site Map](http://www.emacswiki.org/cgi-bin/wiki/SiteMap).


# ELPA: the Emacs Lisp Package Archive

The [Emacs Lisp Package Archive](http://tromey.com/elpa) (ELPA) is a package
manager for Emacs. As of Emacs 24, it will be included as part of the base
Emacs installation.

When you run the installation code (instructions are on the ELPA Web
site), it adds a bit of elisp to your .emacs file that loads the package
manager. I've modified that code by adding the "marmalade" user-contributed
package repository. See the top of
my [emacs.el](http://github.com/jimm/elisp/tree/master/emacs.el).

<em>Note</em>: the last time I installed ELPA on a new Mac OS X system,
the installation failed. It seems like a Catch 22: the code that loads elpa
requires the package manager package be fully installed (including the
versioned subdirectory that holds the package manager code, but it's not
installed yet. This is the first time the install failed; it always worked
for me before. After I copied my elpa directory from another machine,
everything has been fine. I've emailed the author of ELPA about this but
have not received any reply.

Run `M-x package-list-packages` to see what packages are
installed on your system and to add, delete, or upgrade packages.

I've decided to keep my elpa directory in ~/.emacs.d instead of checking
it in to my git repo.

# Expanding words dynamically

Tired of typing a `reallyLongVariableName`? After you've typed
it once, you never have to type it again. Type the first few characters, then
type `M-/` (`dabbrev-expand`), which expands the
previous word by looking for the most recent word that matches. If nothing is
found in the current buffer before point, it looks after point. If it's not
found in the current buffer, then other buffers are searched until it is
found.

If the wrong word is found, type `M-/` again and it will look
for another word that matches the characters you typed, replacing its first
guess with another. Lather, rinse, repeat.

After you get this key combination under your fingers, you will find it
speeds up almost any editing task you perform in Emacs. For example, when
writing a Java method how much time do you spend typing the parameter names?
With `dabbrev-expand` that time is greatly reduced.

~~~ java
public MyClass(String firstArgument, int secondArg,
               Thing absurdlyLongName)
{
  this.firstArgument = firstArgument;
  this.secondArg = secondArg;
  this.absurdlyLongName = absurdlyLongName;
}
~~~

When I typed that just now, I typed the first line (then I wrapped it, but
never mind about that). For the three lines that are the body of the
constructor, I used `dabbrev-expand`. On the first line of the
body, I typed

~~~ java
this.f
~~~

then I typed `M-/`. Emacs found "firstArgument" and replaced the
"f" with "firstArgument". Next, I typed " = f", `M-/`, and ";" to
finish the line.

~~~ java
this.firstArgument = firstArgument;
~~~

After that, I didn't even have to type "this"; I just typed "t" then
`M-/`. Sure, that only saves me one character (two, if you use Alt
or Option as your Meta key) but it's fun.

Remember, don't think locally, think globally. If you are editing one file
but need to type in the name of something that's in another buffer, go ahead
and use `dabbrev-expand`.

I like to make sure case is preserved when expanding, so in my .emacs I
have

~~~ emacs-lisp
(setq dabbrev-case-replace nil)
~~~

# Bookmarks

Bookmarks remember positions within files. They have names, and are
remembered between your Emacs sessions. Even when the contents of a file
changes, the bookmark still works. That's because the bookmark remembers not
only the absolute position in a file, but also remembers what text was around
it. If the file changes drastically, the bookmark may no longer work.

Bookmarks are like registers that store file locations. The default key
binding for setting a bookmark is `C-x r m BOOKMARK &lt;RET&gt;`
(where BOOKMARK is a name for which you are prompted in the mini-buffer). For
jumping to a bookmark, the default key binding is `C-x r b BOOKMARK
&lt;RET&gt;`. `C-x r l` lists all of your bookmarks, and
`M-x bookmark-save` saves all of your bookmarks into the default
bookmark file (see below about `bookmark-save-flag`). Finally,
`M-x edit-bookmarks` displays all your bookmarks and lets you
manage them.

I have `bookmark-jump` bound to `F9` and
`bookmark-set` bound to `F10`. Here's how to do
that:

~~~ emacs-lisp
(define-key global-map [f9] 'bookmark-jump)
(define-key global-map [f10] 'bookmark-set)
~~~
 
The variable `bookmark-save-flag` controls when Emacs saves
bookmarks to the file `bookmark-default-file` (which is
`~/.emacs.bmk` by default). See the documentation for that variable
for its possible values. I set it to 1, which means the bookmarks are saved
every time I make or delete a bookmark. Because of that, I never have to run
`M-x bookmark-save` manually.

~~~ emacs-lisp
(setq bookmark-save-flag 1)		; How many mods between saves
~~~

# abbrev-mode

Related to [`dabbrev-expand`](#dabbrev-expand), which completes words based
on the proceeding characters, is `abbrev-mode` which takes abbreviations you
define and expands them into whatever text you like as you type. You can use
`abbrev-mode` for simple expansions like replacing "Emacs" with "Eight Megs
And Constantly Swapping", or an abbreviation can run a
[skeleton](#skeletons) that optionally prompts for a string and inserts text
that uses that string and leaves the cursor at a particular spot.

Abbreviation definitions can be mode-specific, which means that a
particular abbreviation will only work within that mode. I have a number of
useful abbreviations defined for may programming languages. For example, in
Java mode I use the abbreviation "foriter" to insert a skeleton that ends up
looking like this, properly indented, with "XX" replaced by the string that
the skeleton prompts me for. The cursor ends up on the second line, indented to
the proper place (that's a feature of the skeleton, not
`abbrev-mode`).

~~~ java
for (Iterator iter = XX.iterator(); iter.hasNext(); ) {
    <- cursor ends up here
}
~~~

I have defined "iternext" to insert a skeleton that uses iter.next(), with
the "SomeType" you see below replaced by whatever I give at the skeleton's
prompt. The cursor ends up where the X is; the X isn't part of the
skeleton.

~~~ java
for (Iterator iter = XX.iterator(); iter.hasNext(); ) {
    SomeType X = (SomeType)iter.next();
}
~~~

As soon as you type the space following an abbreviation, Emacs performs the
expansion. What if you want to type an abbreviation literally, without having
it expanded? To do that, quote the space following the abbreviation by typing
`C-q SPACE`.

Here are the bits of my `.emacs` file related to
`abbrev-mode`.

~~~ emacs-lisp
; (setq abbrev-file-name (concat *my-emacs-lib-dir* "abbrev_defs.el"))
; I define *my-emacs-lib-dir* in my .emacs; see that section for details
(setq abbrev-file-name ("path/to/your/abbrev_defs.el"))
(read-abbrev-file abbrev-file-name t)
(setq dabbrev-case-replace nil)  ; Preserve case when expanding
(setq abbrev-mode t)
~~~

Use `C-x a g` to define a global abbreviation and `C-x a
l` to define an abbreviation that is specific to the current major mode.
Abbreviations are stored in `~/.abbrev_defs`. These days, I just
edit that file directly instead of using those hard-to-remember keyboard
commands.

Here is an excerpt from my `abbrev_defs.el` file. The first two
abbreviation definitions don't insert literal text; they run skeletons. The
rest of the abbreviations perform simple text substitutions.

~~~ emacs-lisp
(define-abbrev-table 'java-mode-abbrev-table '(
    ("foriter" "" java-iter-skeleton 0)
    ("iternext" "" java-iter-next-skeleton 0)
    ;; ...
    ("logdebug"
     "org.apache.log4j.Logger.getLogger(getClass().getName()).debug()"
      nil 1)
    ;; ...
    ("ctc" "<code>true</code>" nil 1)
    ("cfc" "<code>false</code>" nil 1)
    ("cnc" "<code>null</code>" nil 1)
    ))
~~~

# Binding (function) keys

Customizing key bindings is easy. You can bind keys globally or per mode.
To bind a key globally, use `global-set-key`. Here are but a few of
my global key bindings.

~~~ emacs-lisp
(global-set-key "\C-c=" my-shell)
(global-set-key "\M-`" 'ff-find-other-file)
(global-set-key "\C-c1" 'find-grep-dired)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-k" 'compile)
~~~

To set a key binding for a mode, put it in the mode hook and use the mode's
key map. Here are a few examples.

~~~ emacs-lisp
(setq html-mode-hook
      '(lambda ()
	 (auto-fill-mode 1)
	 (define-key html-mode-map "\C-c\C-p" 'php-mode)
	 (define-key html-mode-map "\C-c;" 'my-html-insert-comment)
	 ))
(setq sgml-mode-hook
      '(lambda ()
	 (require 'tex-mode)
	 (auto-fill-mode 1)
	 (define-key sgml-mode-map "\C-c\C-f" 'my-docbook-file)
	 (define-key sgml-mode-map "\C-c\C-v" 'tex-view)
	 (define-key sgml-mode-map "\C-c\C-p" 'tex-print)
	 (define-key sgml-mode-map "\C-c=" my-shell)
	 ))
~~~

See Emacs info for the syntax for the strings that represent key strokes.
Generally, it's "\C-x" for control-X, "\M-x" for meta-x, and "\M-\C\x" for
meta-control-x. For function keys, you can use "[f1]" <em>without</em> the
quotes, like this:

~~~ emacs-lisp
(define-key global-map [f3] 'calendar)
(define-key global-map [f4] 'my-visit-todo)
(define-key global-map [f5] 'call-last-kbd-macro)
(define-key global-map [\M-f5] 'apply-macro-to-region-lines)
~~~

# Snippets

Use [yasnippet](http://code.google.com/p/yasnippet/), which is a template
system that gives you TextMate-like snippets. This means that you type a
short key, then tab, and it is expanded into fuller text. The cool part is,
after expansion parts of the new text may be highlighted, ready for you to
change. Each press of the tab key moves you to the next highlighted area
where you can just start typing to replace the default value that is there.
These snippets can do much more: each section can appear more than once (but
you only type once and what you type appears in all the other places) and
each section can run elisp code to modify what you type there or elsewhere.

It's easy to write your own snippets. Here's a simple one that turns
"cncTAB" into "&lt;code&gt;null&lt;/code&gt;". I use it when writing
Javadocs.

~~~
#name: <code>null</code>
# --
<code>null</code>
~~~

Here's one that I wrote that creates a stub Java class, complete with the
proper class name deduced from the file name and package deduced by running
a function that looks at the file system.

~~~
#name: public class XXX { ... }
# --
package `(path-to-java-package (buffer-file-name))`;

public class ${1:`(substring (file-name-nondirectory (buffer-file-name)) 0 -5)`} {
    $0
}
~~~

Here's one that turns "ivarTABStringTABfoo" into an instance variable
declaration, a getter, and a setter:

~~~
#name: ivar declaration and accessors
# --
protected ${1:Object} ${2:ivar};
$0
public $1 get${2:$(capitalize-first-char-of-string text)}() { return $2; }
public void ${1:$(if (equal (downcase text) "boolean") "is" "set")}${2:$(capitalize-first-char-of-string text)}($1 value) { ${2:$(if (equal text "value") "this.value" text)} = value; }
~~~

# Skeletons

_(Note that there are a few nice **skeleton replacements**. I've
started using [yasnippets](http://code.google.com/p/yasnippet/) instead of
skeletons.)_

Skeletons are fill-in-the-blank templates. Here's a simple example that
prompts for some text, inserts "`&lt;%= link_to('Whatever you typed'),
:action => '' %>`", and leaves the cursor between the last two single
quotes:

~~~ emacs-lisp
(define-skeleton rails-link-to-skeleton
  "Inserts link_to"
  "Link text: "
  "<%= link_to('" str "', :action => '" _ "') %>")
~~~

The first string is a comment. If the symbol `str` is used in
the skeleton, then the second string is a prompt string that is not inserted.
The rest of the skeleton consists of strings, characters, and symbols such as
"_", which is where the cursor ends up after the skeleton is inserted.

There are many more magic symbols that can appear in skeletons. "\n" goes
to the next line and indents according to the buffer's major mode. ">" indents
according to the buffer's major mode. The documentation for the
function `skeleton-insert` gives a good description of what can be
in the body of a skeleton.

I have lots of skeletons that do things like create Java instance variables
with their accessor methods. Here is a slightly more complicated example:

~~~ emacs-lisp
(define-skeleton java-testcase-skeleton
  "Inserts a TestCase class skeleton"
  > "package " (path-to-package (buffer-file-name)) ";" \n
  "import junit.framework.TestCase;" \n
  \n
  > "public class "
  (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))
  " extends TestCase {" \n
  \n
  > "protected void setUp() {" \n
  > _ \n
  "}" > \n
  \n
  > "protected void tearDown() {" \n
  "}" > \n
  \n
  > "public void testDummy() {" \n
  > "assertTrue(true);" \n
  "}" > \n
  "}" \n
  )
~~~

That skeleton creates a TestCase Java class in the current buffer. The
package name is automatically calculated by `path-to-package` (see
below). Why does that skeleton have both "\n" and ">", if "\n" performs a
newline then indent? Because sometimes the lines have to be re-indented. Play
around with the newline and indent symbols in the skeleton and you'll see what
I mean.

Bonus: here's the code to `path-to-package`.

~~~ emacs-lisp
(defun path-to-package (path)
  "Returns a Java package name for PATH, which is a file path. Looks for 'src'
in PATH and uses everything after that, turning slashes into dots. For
example, the path /home/foo/project/src/com/yoyodyne/project/Foo.java becomes
'com.yoyodyne.project'. Even if PATH is a directory, the last part of the path
is ignored. That is a bug, but it's one I can live with for now."
  (interactive)
  (mapconcat
   'identity
   (reverse (upto (cdr (reverse (split-string path "/"))) "src"))
   "."))
~~~

I also bind `path-to-package` to the abbreviation "package" in
java-mode. This means that whenever I type "package" in a Java file, the
package name is automatically inserted.

Skeletons are much more complicated than I've described here. I've only
learned the basics, myself. For example, skeletons can contain other
skeletons that use `str`. The inner skeleton is called in a loop,
and is expanded each time until the user enters an empty string. 

Skeletons combine nicely with [`abbrev mode`](#abbrev-mode). Here's how to
make `java-testcase-skeleton` run whenever you type "testcase" in a Java
buffer. This code goes in your abbrev_defs.el file.

~~~ emacs-lisp
(define-abbrev-table 'java-mode-abbrev-table '(
    ;; ... lots of other abbrevs not shown ...
    ("testcase" "" java-testcase-skeleton 0)
    ))
~~~

# Eshell

# Tags and M-.

Jealous of IDE users that can jump to...[write more]

Write about `tags-reset-tags-tables</code></p>

# Registers

# Compile

# Timed events

# Org mode

# Encryption

# Customizing indentation

# Calendar

# Diary

# Time zone, latitude, and longitude

# Font lock mode and colors

# Hex editor
