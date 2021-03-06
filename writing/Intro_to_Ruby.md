---
layout: default
---
# Introduction to Ruby for Mac OS X

**The Principle of Lease Surprise**

    This article was originally published as the cover article in
    /MacTech Magazine/ 19.3 (March 2003). It has been reformatted
    for this site.

# Introducing Ruby

Yukihiro "Matz" Matsumoto was looking for an object oriented scripting
language. Python wasn't OO enough. Perl's "Swiss Army Chainsaw" approach was
too messy. When he didn't find what he was looking for, Matz decided to write
his own language. His goal was to create one good enough to replace Perl. Ruby
was born in February of 1993 and first released to the public in 1995. Today,
Ruby is more popular than Python in Japan. Ruby started hitting the shores of
the United States around 2000.

Here's how I think of Ruby. Take Smalltalk, where everything&mdash;even a
number&mdash;is an object. Make it a file-based, interpreted scripting
language. Give it a syntax familiar to Perl and Python users. Add the best
features of many different languages such as regular expressions, iterators,
block closures, garbage collection, and dynamic typing. Abstract many features
into classes like <code>Regexp</code> and mixin modules like
<code>Enumerable</code>. Deliver it with a mature, useful set of library
modules. Finally, add a helpful and responsive developer community. The result
is a language that is easy to learn, powerful, and a joy to use.

I've fallen in love with Ruby. It's a pure object oriented scripting language.
It's simple, consistent, and powerful. It stays out of my way and makes me
more productive. Best of all, it comes pre-installed with Jaguar. Open a
terminal window and type <span class="cmd">ruby -v</span>. See? If you aren't
yet running Jaguar, you can download Ruby from the <a
href="http://www.ruby-lang.org/en/">Ruby home page</a> and compile and install
it yourself.

To attempt to illustrate why I like Ruby so much, let's take a look at the
same class written in Java, Objective-C, Perl, and Ruby. <a
href="#listing1">Listing 1</a> defines a <code>Song</code> class with two
instance variables, accessor (getter and setter) methods, a method that
converts the song to a string for printing, and code to create a
<code>Song</code> object and print it. The Ruby code is smallest and cleanest
(therefore easiest to understand and maintain) without being terse or
obfuscated.

<a id="listing1"/>
<pre class="code">
<span class="listing-title">
Listing 1: song.java, song.m, song.pl, song.rb
</span>
<span class="listing-summary">
Java, Objective-C, Perl, and Ruby code samples that each do
the same thing: define a simple Song class and use it.
</span>
// ======== Java (song.java) ========

public class Song {

    protected String name;
    protected int lengthInSeconds;

    Song(String name, int len) {
        this.name = name;
        lengthInSeconds = len;
    }

    public String getName() { return name; }
    public void setName(String str) { name = str; }

    public int getLengthInSeconds() {
        return lengthInSeconds;
    }

    public void setLengthInSeconds(int secs) {
        lengthInSeconds = secs;
    }

    public String toString() {
        return name + " (" + lengthInSeconds + " seconds)";
    }

    // Create and print
    public void main(String[] args) {
        s = new Song("name", 60);
        System.out.println(s);
    }
}

// ======== Objective-C (song.m) ========

#import &lt;Foundation/NSString.h&gt;

@interface Song : NSObject
{
    NSString *name;
    int lengthInSeconds;
}

- initWithName:(NSString *)name length:(int)length;
- (void)dealloc;

- (NSString *)name;
- (void)setName:(NSString *)name;

- (int)lengthInSeconds;
- (void)setLengthInSeconds:(int)length;

- (NSString *)description;
@end

@implementation Song

- initWithName:(NSString *)nameString length:(int)length
{
    [super init];
    [self setName:nameString];
    [self setLengthInSeconds:length];
    return self;
}

- (void)dealloc
{
    [name release];
    [super dealloc];
}

- (NSString *)name { return name; }

- (void)setName:(NSString *)nameString
{
    [name autorelease];
    name = nameString;
    [name retain];
}

- (int)lengthInSeconds { return lengthInSeconds; }

- (void)setLengthInSeconds:(int)length
{
    lengthInSeconds = length;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%d seconds)",
        [self name], [self lengthInSeconds]];
}

@end

int main(int argc, char *argv[])
{
    // Create and print
    Song *song = [[Song alloc] initWithName:@"name"
                     length:60];
    NSLog(@"%@", song);
    return 0;
}

// ======== Perl (song.pl) ========

package Song;

sub new {
    my($class, $name, $len) = @_;
    my $self = {};
    $self->{'name'} = $name;
    $self->{'lengthInSeconds'} = $len;
    bless $self, class;
    return $self;
}

sub name {
    my($self) = shift;
    if (@_) { $self->{'name'} = shift }
    return $self->{'name'};
}

sub lengthInSeconds {
    my($self) = shift;
    if (@_) { $self->{'lengthInSeconds'} = shift }
    return $self->{'lengthInSeconds'};
}

sub toString {
    my($self) = shift;
    return $self->name() . "(" . $self->lengthInSeconds()
        . ") seconds";
}

# Create and print
$s = Song->new('name', 60);
print $s->toString() . "\n";

// ======== Ruby (song.rb) ========
class Song

  # Not only declare instance variables (which is
  # unnecessary) but also create accessor methods
  # (getters and setters).
  attr_accessor :name, :length_in_seconds

  # The constructor, sort of. This method is called
  # by the class method "new".
  def initialize(name, len)
    @name = name
    @length_in_seconds = len
  end

  def to_s
    return "#{@name} (#{@length_in_seconds} seconds)"
  end
end

# Create and print.
s = Song.new('name', 60)
puts s
</pre>

This article will cover Ruby's language features, syntax, built-in classes,
and libraries. We'll review a few Mac OS X-specific modules, look at some
sample code, and leave you with a list of resources. This isn't a tutorial or
a complete description of Ruby's features and idioms. There are a number of
excellent Ruby books and online resources available that can fill in the
details. See the <a href="#resources">Resources</a> section below for a list.

# Ruby's Features

This section attempts to briefly describe many of Ruby's features. Please bear
in mind that there isn't enough room in this article to list everything or
even fully explain or justify each item.

## Object Orientation

Ruby's object oriented nature is consistent and complete. Everything is an
object or a method. Even numbers are objects and even operators are methods.
You may see code that looks like it is calling a global function; that is
because the top-level code is actually executing within the context of an
invisible magical variable representing the script's main module. This object
includes the <code>Kernel</code> module, giving it access to methods such as
<code>print</code>, <code>chop</code>, <code>system</code>,
<code>sleep</code>, and all the others you might expect from a scripting
language. You can write code that looks procedural, but it really isn't.

Classes inherit via single inheritance but can include multiple modules.
Modules provide name spaces and&mdash;unlike Java's interfaces&mdash;method
implementations. Like Smalltalk but unlike C++ or Objective-C, a metaclass
(the class of a class) is a full-blown class itself, with instance variables
and methods.

Classes remain "open" so you can add or replace methods for any class at any
time. Go ahead: add a method to the <code>String</code> class! Methods can
also be added to individual objects, giving them unique behavior.

Introspection and reflection let objects and classes inspect and manipulate
their instance variables and methods.

Mark-and-sweep garbage collection (superior to Python's reference counting
scheme) means you don't have to worry about memory management.

## The Language

Ruby's syntax is simple and consistent. The language has been designed using
the Principle of Least Surprise: things work the way you expect them to, with
very few special cases or exceptions.

Variable naming rules are simple. The first character determines a variable's
use: <code>@instance_variable</code>, <code>@@class_variable</code>,
<code>$global</code>, <code>CONSTANT</code>, <code>:symbol</code> and
<code>everything_else</code>. This is different from Perl, where the first
character determines the variable's type. We'll cover variable and method
names in more detail later.

Before going any further, let's look at some Ruby code. <a
href="#listing2">Listing 2</a> implements a jukebox full of songs to play.
This version gets its list of songs by reading the names of the files that
iTunes stores in your Music directory. We'll augment this code later by using
the RubyAEOSA module (available separately) to add AppleScript that talks
directly to iTunes.

The first line of this script isn't Ruby code; it's a magical incantation that
tells the shell what program to run to execute the script. Instead of
hard-coding the path to the Ruby executable&mdash;which could be in
<code>/usr/bin/ruby</code>, <code>/usr/local/bin/ruby</code>, or even
somewhere else depending upon how it was configured when Ruby was
installed&mdash;we use the env program to figure out where the Ruby executable
lives.

<a id="listing2"/>
<pre class="code">
<span class="listing-title">Listing 2: jukebox1.rb</span>

<span class="listing-summary">
This jukebox reads the filesystem to retrieve the names of all of
your iTunes files. It prints all artists' names and their album
names. It then prints all of the song names from the album you
specify and "plays" each of the songs from that album whose names
start with a vowel.
</span>
#! /usr/bin/env ruby
#
# usage: jukebox1.rb [itunes-dir] [artist-name] [album-name]
#
# If itunes-dir, artist-name, or album-name are unspecified,
# default values (defined below) are used.
#
# Normally, I would put each class in its own file.

# This constant holds the name of the iTunes music directory
DEFAULT_ITUNES_DIR =
  "#{ENV['HOME']}/Music/iTunes/iTunes Music"

# A regular expression for making file names palatable
# to the Dir class file name globbing.
FNAME_BAD_CHARS_REGEX = /['"\s]/

# Create a Jukebox class. A Jukebox holds a hash (dictionary)
# whose keys are artist names and values are artist objects.
class Jukebox

  # Declare an instance variable. Declaring it isn't
  # necessary, but by using "attr_accessor" two accessor
  # methods (a getter and a setter) are created for us.
  attr_accessor :artists

  # This method is called by the constructor when a new
  # jukebox is created.
  def initialize
    @artists = Hash.new
  end

  # Return a list of all of the artists' albums.
  def albums
    return @artists.values.collect { | a | a.albums }
  end

  # Load all of the artists, albums, and songs. Provide
  # a default value for the parameter tunes_dir.
  #
  # This isn't the only way to traverse the directory
  # structure, but it will do.
  def load(tunes_dir = DEFAULT_ITUNES_DIR)
    artist_glob = File.join(tunes_dir, '*')
    artist_glob.gsub!(FNAME_BAD_CHARS_REGEX, '?')

    Dir[artist_glob].each { | artist_dir |
      next if artist_dir[0] == ?. # Skip dot files

      artist = Artist.new(File.basename(artist_dir))
      album_glob = File.join(artist_dir, '*')
      album_glob.gsub!(FNAME_BAD_CHARS_REGEX, '?')

      Dir[album_glob].each { | album_dir |
        next if album_dir[0] == ?.

        album = Album.new(File.basename(album_dir))
        song_glob = File.join(album_dir, '*')
        song_glob.gsub!(FNAME_BAD_CHARS_REGEX, '?')

        Dir[song_glob].each { | song |
          song_name = File.basename(song)
          next if song_name[0] == ?.

          # Add the song to the album's song list
          album.songs &lt;&lt;
            Song.new(song_name.sub(/\.mp3$/, ""))
        }
        artist.albums[album.name] = album
      }
      @artists[artist.name] = artist
    }
  end

end

class Nameable

  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def to_s
    return @name
  end
end

class Artist &lt; Nameable

  attr_accessor :albums

  def initialize(name)
    super(name)
    @albums = Hash.new
  end
end

class Album &lt; Nameable

  attr_accessor :songs

  def initialize(name)
    super(name)
    @songs = []
  end
end

class Song &lt; Nameable

  alias_method :title, :name          # Make song respond to
  alias_method :title=, :name=        # "title" and "title="

  def play
    puts "Played song #{title()}"     # See? title() works
  end
end

# ==========================================================

# This code will only execute if this file is the file
# being run from the command line.
if $0 == __FILE__

  DEFAULT_ARTIST = 'Thomas Dolby'
  DEFAULT_ALBUM = 'Astronauts And Heretics'

  fave_artist_name = ARGV[1] || DEFAULT_ARTIST
  fave_album_name = ARGV[2] || DEFAULT_ALBUM

  jukebox = Jukebox.new
  jukebox.load(ARGV[0] || DEFAULT_ITUNES_DIR)

  # Print some stuff

  puts "All Artists:"
  puts "\t" + jukebox.artists.keys.join("\n\t")

  puts "#{fave_artist_name}'s albums:"
  artist = jukebox.artists[fave_artist_name]
  artist.albums.each_value { | album |
    puts "\t#{album.name}"
    puts "\t\t" + album.songs.join("\n\t\t")
  }

  puts "\"Play\" all songs from \"#{fave_album_name}\"" +
    " that start with a vowel"
  album = artist.albums[fave_album_name]

  # Make a new list by rejecting (skipping) songs that
  # do not start with a vowel.
  vowel_songs = album.songs.reject { | song |
    song.name =~ /^[^aeiou]/i
  }
  vowel_songs.each { | song | song.play }

end
</pre>

In Ruby, variables generally hold references to objects. Thus Ruby is strongly
typed but dynamic. Dynamic typing leads to quicker implementation. The benefit
becomes apparent when you decide to change your application's phone numbers
from strings to objects of class <code>MyPhoneNumber</code>. You don't have to
change your code everywhere.

Closures are code blocks that remember their context including local variables
declared outside the block, the value of <code>self</code>, and more. They
provide a way to pass snippets of code to iterators or methods. <a
href="#listing3">Listing 3</a> shows a block being passed to an array's
collect method. It also shows that any local variables defined when the block
is created are available to the block.

<a id="listing3"/>
<pre class="code">
<span class="listing-title">Listing 3: blocks.rb</span>

<span class="listing-summary">
In this example, we create an array and a local variable. We then
call the array's collect method, passing a block that uses the
local variable.
</span>
#! /usr/bin/env ruby

a = [1, 2, 3]
x = 5

# Pass a block to the collect method. The collect method
# calls the block once for each element in the array,
# passing the element to the block. (The method p calls
# its arguments' inspect method, which is defined in the
# Object class but may be overridden.)
b = a.collect { | elem | elem + x }
p a                # prints [1, 2, 3]
p b                # prints [6, 7, 8]
</pre>

The keyword <code>yield</code>, when used within a method, calls the block
passed to the method. This gives blocks one more nifty use: adding
behind-the-scenes behavior before or after the block is executed. For example,
when the open method of the built-in <code>File</code> class is given a block
argument, it not only passes the opened file into the block but it
automatically closes the file when the block exits. <a
href="#listing4">Listing 4</a> shows how that happens.

<a id="listing4"/>
<pre class="code">
<span class="listing-title">Listing 4: autoclose.rb</span>

<span class="listing-summary">
This is how the open method of the File class can automatically
close a file for you. It also shows how you specify default method
argument values. The block isn't declared in the method's
signature. It must be the last thing passed in when the method is
called.
</span>
#! /usr/bin/env ruby

# In Ruby, you can add code to any class at any time.
class File

  # The real File.open method is probably a bit more
  # robust than this.
  def File.open(file_name, mode_string = "r", perm = nil)
    f = File.new(file_name, mode_string, perm)
    yield f    # Execute the block, passing the file to it
    f.close()
  end

  # We want to redefine close() but call the original
  # version. We can't just call super() because we are
  # not creating a subclass. Instead, we create a new
  # name for the original version of the method, then
  # use that name inside the redefined method. (This
  # implies that alias_method really clones the method
  # definition instead of simply creating a new name.)
  alias_method :old_close, :close
  def close
    old_close()
    $stdout.puts "file has been closed"
  end

end

File.open(some_file_name) { | f |
  # do something with the file...
}
# "file has been closed" will be printed to stdout.
</pre>

Traversing a list of values is one of the most common things done in any
program. Ideally, while enumerating the elements of a list you don't care how
many things are in the list or what type of object each thing is. In Ruby,
enumeration has been abstracted into a mixin module available to all classes
and independent of the language syntax. Built-in classes like
<code>Array</code>, <code>Dir</code>, <code>Hash</code>, <code>IO</code>,
<code>Range</code>, and <code>String</code> all mix in (include) the
<code>Enumerable</code> module. If a class includes the
<code>Enumerable</code> module and implements one method called
<code>each</code> that takes a block argument, it gets all the other methods
for free: <code>each_with_index</code>, <code>sort</code>,
<code>collect</code>, <code>detect</code>, <code>reject</code>,
<code>select</code>, <code>entries</code>, <code>find</code>,
<code>grep</code>, <code>include?</code>, <code>map</code>, <code>max</code>,
and more.

The <code>Range</code> class represents ranges of integers or strings.
<code>(0..3)</code> is syntactic sugar that creates a <code>Range</code>
object that will generate the values 0, 1, 2, and 3. <code>(0...3)</code> will
generate 0, 1, and 2. Two dots means "include the final value", three dots
means "exclude it".

A method's name can be aliased, meaning that more than one name can refer to
the same method. Can't decide between <code>indexes</code> and
<code>indices</code>? Can't remember if it's <code>array.size</code> or
<code>array.length</code>? That's OK: use either one. The built-in classes
make use of aliases to let you decide. We used <code>alias_method</code> in <a
href="#listing2">Listing 2</a> so a song's name could be referred to as its
title.

Ruby's exception mechanism is similar to Java's. You can raise exceptions,
rescue (catch) them, and re-throw them. Within the rescue block, if you can
fix the error you can use retry to jump back to the top of the block. See
<a href="#listing5">Listing 5</a> for an example.

<a id="listing5"/>
<pre class="code">
<span class="listing-title">Listing 5: exceptions.rb</span>

<span class="listing-summary">
An example of exception handling and retrying. This script will
throw the "argument was true" exception the first time it is run.
After the fixing the cause of the exception, it uses "retry" to
cause the begin block to start over.
</span>
#! /usr/bin/env ruby

def raise_error_if_true(flag)
  raise "argument was true" if flag
end

def always_executed
  puts "always executed"
end

silly_flag = true
begin
  raise_error_if_true(silly_flag)
  puts "silly_flag was false"
rescue => ex
  $stderr.puts "error: #{ex.message()}; trying again"
  silly_flag = false
  retry
ensure
  # This is exactly like Java's "finally" keyword:
  # code here will always be executed.
  always_executed()
end

# The output of this script will be:
# error: argument was true; trying again
# silly_flag was false
# always executed
</pre>

In Ruby, boolean expressions are slightly different than what you are probably
used to: only <code>nil</code> and <code>false</code> are false; everything
else (including the number 0 and empty strings, arrays, and hashes) evaluates
to true.

# The Rest of the World

Ruby is written in C. Not only does this make Ruby reasonably fast, but it
makes integration with existing C code easy. You can extend Ruby with C code
or embed a Ruby interpreter within your C code.

Because Ruby is written in C, it has been ported to many different operating
systems. Ruby runs under Mac OS 9 and OS X, BSD, Linux, Solaris, BeOS, OS/2,
DOS, Windows 95/98/NT/2K, and more. Ruby can also load libraries dynamically
on operating systems like Mac OS X that support it.

As with most scripting languages, it is easy to execute commands just like you
would from the command line. You can run Unix commands or even launch Mac
applications by using the system method or enclosing the command in
backquotes. The <code>system</code> method runs the command and returns the
exit status; using backquotes returns the output of the command as a string.

In the section <a href="#macosx">Ruby and Mac OS X</a> below we will take a
look at some modules that add Apple Event support and Cocoa integration to
Ruby.

Ruby is a great language for building Web-based applications. The Web server
built in to OS X is Apache, which can be configured and extended through the
use of modules (not Ruby modules) such as those used to add PHP, Fast CGI,
and&mdash;you guessed it&mdash;Ruby. The Apache module mod_ruby adds support
for Ruby CGI scripts and the eRuby Ruby module adds support for Ruby embedded
into HTML, just like PHP or JSP.

Any scripting language used for Web services and page scripting, system
administration, and network communications needs some security measures. For
example, Ruby allows any string to be executed as code using the eval method.
If that string is supplied from someplace outside the script itself such as a
file or user input, it may contain destructive or harmful code. The value of
the global variable <code>$SAFE</code> determines how much Ruby trusts data
stored in its variables. Data is either "tainted" or "untainted". Tainted data
is that which has been supplied externally (for example, use input or file
data). By default (when <code>$SAFE == 0</code>), Ruby trusts all data. Larger
values of <code>$SAFE</code> cause Ruby to disallow the use of tainted data,
prohibit loading programs from unsafe locations, distrust all newly created
objects, or prevent modification of untainted objects. Objects can also be
"frozen" to prevent further changes.

Ruby implements operating system-independent threading. The good news is that
the threading model is highly portable; your threads will work under Jaguar or
DOS. The bad news is that Ruby does not yet take advantage of an operating
system's underlying threading, if any.

In the next major release of Ruby, Matz plans to add support for
internationalization and multilingualization throughout Ruby. In 1.6.7, the
only internationalization support is via the String class and the kconv
module, which support a small number of codings, including UTF and Kanji.

The <a href="http://jruby.sourceforge.net/">JRuby</a> project is a pure Java
implementation of the Ruby interpreter. A module available at the <a
href="http://raa.ruby-lang.org/">Ruby Application Archive</a> (RAA) provides
integration with Objective-C. See "Ruby and Mac OS X" below.

# Syntax

Ruby's syntax is so close to Perl's and Java's that it won't take long to
learn. I was writing tiny but useful scripts a few hours after installing
Ruby.

Each line of code is a new statement. Semicolons are optional and unnecessary
unless you need more than one statement on a line. To continue a line of code
on multiple lines, end the line with something that logically continues the
line: a comma or operator, for example.

To create a new object, use <code>thing = ClassName.new(arguments)</code>.
Each class can define the method <code>initialize</code> which is called by
the constructor. You can use <code>attr_accessor</code> and friends to
automatically create accessor methods (setters and getters). See <a
href="#listing6">Listing 6</a> for an example that defines a simple class with
a instance variable definition that uses <code>attr_accessor</code> to
automatically generate accessor methods and another that uses
<code>attr_reader</code> to generate a getter but no setter.

<a id="listing6"/>
<pre class="code">
<span class="listing-title">Listing 6: constructors.rb</span>

<span class="listing-summary">
An example of constructors and automatically generated accessors.
</span>
#! /usr/bin/env ruby

class MyClass

  # attr_accessor creates setter and getter methods for
  # the listed symbols (instance variable names)
  attr_accessor :name

  # attr_reader creates a getter but not a setter.
  attr_reader :the_answer

  def initialize(name="DefaultName")
    @name = name
    @the_answer = 42
  end

  # The method to_s is like Java's toString() method.
  def to_s
    "My name is #{@name}; the answer is #{@the_answer}."
  end
end

my_thing = MyClass.new("Ruby")
my_thing.name = 'New Name'

# If this line was uncommented, an exception would be
# thrown stating "undefined method `the_answer='"
# my_thing.the_answer = 3

puts my_thing.to_s
</pre>

As mentioned previously, a variable's use is determined by the first character
of its name: <code>@instance_variable</code>, <code>@@class_variable</code>,
<code>$global</code>, <code>CONSTANT</code>, <code>:symbol</code>, and
<code>everything_else</code>. Note that Ruby class and module names must start
with capital letters. This implies they are constants.

By convention, method and variable names are all lowercase and words are
<code>separated_by_underscores</code>. This is not enforced by the parser.
Another convention that may look unfamiliar at first is the use of
<code>?</code> and <code>!</code> in method names. Method names that end with
<code>?</code> return boolean values. Examples include
<code>Object.nil?</code> and <code>Array.empty?</code>. Method names ending
with <code>!</code> modify the receiver. For example,
<code>String.strip</code> returns a new copy of the receiver with leading and
trailing whitespace removed; <code>String.strip!</code> modifies the receiver
by removing leading and trailing whitespace.

A <code>Symbol</code> is a unique identifier. All occurrences of the same
symbol share the same instance. Symbols are used to represent method and
instance variable names and can also act as unique values for constants (think
C's enums). Symbols have both string and integer representations.

Parentheses around method arguments are optional. Beware, though: leaving them
out can occasionally cause unexpected results. Instead of memorizing complex
rules, do what I do: when in doubt, use parentheses.

Arrays are created using either <code>a = Array.new</code> or <code>a = [1,
'foo', thing]</code>. The <code>new</code> method takes two optional
arguments: array size and initial value. Hashes (also called hash maps,
associative arrays, or dictionaries) are created using either <code>h =
Hash.new</code> or <code>h = {'a' => 1, 'b' => 'foo', 'c' => thing}</code>.
The <code>new</code> method takes one optional argument: the default value for
undefined hash keys.

String constants can be contained within double or single quotes. When
surrounded by double quotes, the contents of the string are interpolated. All
occurrences of <code>"#{x}"</code> within the string are replaced by the value
of x. Note that x may be anything: a variable, an expression, or an entire
block of code. As a shortcut, <code>"#{$var}"</code> may be written as
<code>"#$var"</code> and <code>"#{@instance_var}"</code> as
<code>"#@instance_var"</code>.

The <code>[]</code> and <code>[]=</code> (assignment) methods of String can
take an integer and return a single character, take two integers (starting
index and length) to return a substring, or even take a regular expression and
return the substring matching that expression. See <a href="#listing7">Listing
7</a> for some examples.

One important note: there is no character class in Ruby. When you retrieve a
character from a string you get back its integer value. To retrieve a one
character string you have to ask for a string of length one. See <a
href="#listing7">Listing 7</a>.

To write a character constant, use <code>?</code> before the character. For
example, <code>?A</code> is an upper-case A.

<a id="listing7"/>
<pre class="code">
<span class="listing-title">Listing 7: string_accessor.rb</span>

<span class="listing-summary">
String accessor examples. Additionally, the String class provides
a rich series of methods for string manipulation.
</span>
#! /usr/bin/env ruby

s = "abcdefg"
s[0]            # => 97, the ASCII value of 'a'
s[0,1]          # => "a"
s[1,2]          # => "bc"
s[/b.*f/]       # => "bcdef"
s[0..3]         # => "abcd"
s[0...3]        # => "abc"
s[-4..-1]       # => "defg"

s[0] = ?x       # s == "xbcdef"
s[/b.*f/] = "z" # s == "xzg"
</pre>

Ruby's control structures will be familiar to users of most languages. There's
nothing surprising, except perhaps the use of <code>elsif</code> instead of
<code>else if</code>. Like Perl, you can write <code>do_this() if that</code>
or <code>do_that() unless this</code>.

The <code>case</code> structure (called "switch" in Java and C) is
interesting. The branches use the <code>===</code> method to compare the
target with any other kind of object: a number, a regular expression, or even
a class. See <a href="#listing8">Listing 8</a>.

<a id="listing8"/>
<pre class="code">
<span class="listing-title">Listing 8: case.rb</span>

<span class="listing-summary">
The case statement uses the === method to perform comparisons.
</span>
#! /usr/bin/env ruby

x = 'abcdefg'
case x
when 'xyzzy', 'plugh'            # Compare with constants
  # You can specify multiple potential matches in the
  # same "when" clause.
  puts "xyzzy or plugh"
when /def/                       # Compare with regex
  # Matches; this code will execute because the previous
  # comparison failed.
  puts "found 'def'"
when String                      # Compare x's class with String class
  # This matches, but the previous comparison executed
  # already.
  puts "It's a String, all right"
else
  # The default case, when all others fail
  puts "oops"
end
</pre>

<a href="#listing9">Listing 9</a> contains some examples of enumerating over
objects' contents. Since the <code>Enumerable</code> module can be included in
any class and only requires implementation of one method (<code>each</code>),
it is easy to remember how to use and easy to add to your own classes.

<a id="listing9"/>
<pre class="code">
<span class="listing-title">Listing 9: enumerating.rb</span>

<span class="listing-summary">
Enumerating over an array, a hash, a string, and a
user-defined class.
</span>
#! /usr/bin/env ruby

array = [1, 2, 3]
hash = {"a" => 1, "b" => 2, "c" => 3}
file = File.open($0, "r")        # $0 is this script's name
string = "abc"

# Notice how many different classes access their contents
# the same way because they all import Enumerable and
# implement the "each" method.
array.each { | elem | puts elem }
hash.each { | key, val | puts "#{key} => #{val}" }
file.each { | line | puts line }
string.each { | line | puts line }

# each_with_index is defined in the Enumerable module
array.each_with_index { | elem, i |
  puts "array[#{i}] = #{elem}"
}

# The String class adds the each_byte method, since
# String.each iterates over lines of text, not characters.
# The output will be a list of integers.
string.each_byte { | c | puts c }

# The include? method is defined in the Enumerable module
puts "yup" if array.include?(42)

# Now let's define our own class and make it enumerable.
class TrainTrip

  include Enumerable

  def initialize
   @stops = %w(Paris London Boston Tokyo Kiev)
  end

  # Implement the "each" method when including the
  # Enumerable module. By doing so, all the other
  # methods in that module (each_with_index, sort,
  # collect, detect, reject, select, entries,
  # find, grep, include?, map, max, and more) are
  # available for free.
  #
  # If the last parameter in an argument list starts
  # with an ampersand, then if a block is passed to
  # the method Ruby will convert it into a Proc
  # object.
  def each(&amp;block)
    @stops.each(&amp;block)
  end

end

trip = TrainTrip.new
trip.each_with_index { | stop, i | puts "#{i+1}: #{stop}" }

# Because Enumerable takes care of everything else, we
# get lots more behavior for free.
trip.include?("London")        # => true
trip.sort.each { | stop | puts stop }

file.close
</pre>

# Classes and Libraries

Ruby comes with an impressive and useful library of classes and modules. The
Ruby Application Archive is the best place to find and publish additional Ruby
libraries and applications. When I counted in February of 2003 there were over
800 entries in the archive. They include libraries for Mac OS X, database
access, networking, WWW and CGI programming, XML, unit testing, documentation,
cryptography, AI, graphics, editors, GUI creation, games, and more.

## Built-In Classes

The classes and modules that come with Ruby include value holders
(<code>Array</code>, <code>String</code>, <code>Hash</code>,
<code>Numeric</code>, <code>Range</code>, and <code>Time</code>), I/O classes
(<code>IO</code>, <code>File</code>, and <code>Dir</code>), OO classes
(<code>Object</code>, <code>Class</code>, <code>Module</code>,
<code>Struct</code>, and the <code>ObjectSpace</code> module), operating
system integration classes (<code>Thread</code>, <code>ThreadGroup</code>, and
the <code>Kernel</code> module), regular expression classes
(<code>Regexp</code> and <code>Match</code>), and more.

The hierarchy of numeric classes (<code>Numeric</code>, <code>Float</code>,
<code>Fixnum</code>, and <code>Bignum)</code> provides double-precision
floating point and infinite-precision integer arithmetic. The
<code>Math</code> module provides <code>sin</code>, <code>sqrt</code>,
<code>log</code>, and friends.

Objects can be marshalled&mdash;converted into byte streams and back&mdash;via
the <code>Marshall</code> module. The library module named <code>drb</code>
(Distributed Ruby) found on the Ruby Application Archive combines this ability
with the networking library to provide an easy-to-use framework for writing
distributed Ruby applications.

## Libraries

The standard Ruby distribution comes with a number of libraries including
networking, XML parsing, date manipulations, persistent object storage, Tk (a
cross-platform GUI infinitely less pretty than Aqua), mutex thread
synchronization, MD5 (cryptography), debugging, matrix math and complex
numbers, design patterns like observer/observable and delegation, OpenGL, and
much more.

The standard Ruby libraries are found in <code>/usr/lib/ruby/1.6</code> (or if
you've installed version 1.8 yourself, in <code>/usr/local/lib/ruby/1.8</code>
and used the default install directory). Additional libraries you download and
install usually place themselves in <code>/usr/lib/ruby/site_local/1.6</code>.

<a id="macosx"/>
# Ruby and Mac OS X

Fujimoto Hisakuni has written three Mac OS X Ruby bindings: RubyAEOSA,
RubyCocoa, and an Objective-C binding. They come with plenty of example code.
All three are available within the same package. Download RubyCocoa version
0.3.2 or higher from the RAA. The download is a disk image (".dmg") file
which contains, among other things, a ".pgk" package file. Install the
package and you are ready to use the three libraries. Version 0.3.2 is for
Jaguar only; it won't work with earlier versions of Mac OS X. If you are
running an earlier version, download an earlier version of the libraries and
follow the included installation instructions.

RubyAEOSA lets you send create and send Apple Events, run AppleScript code,
and retrieve the results from either. RubyCocoa allows your scripts to use
Cocoa objects. You can even write small Cocoa applications using Ruby and
Interface Builder.

Let's use some AppleScript to let the jukebox from <a href="#listing2">Listing
2</a> talk directly to iTunes to retrieve song information and play a song.
See <a href="#listing10">Listing 10</a>. Two warnings: first, this AppleScript
takes a few seconds to execute if you have a lot of music, whether it is run
from Script Editor or this Ruby script. Second, for some reason this
AppleScript code kept trying to launch the OS 9 version of iTunes. I had to
move the OS 9 iTunes folder into the Trash and reboot before it would launch
the OS X version. Even then, it started trying to launch the OS 9 version
after a while. I emptied my trash. I'm no AppleScript expert, so all this was
probably my fault.

<a id="listing10"/>
<pre class="code">
<span class="listing-title">Listing 10: jukebox2.rb</span>

<span class="listing-summary">
Add some AppleScript to the jukebox so it can talk to iTunes.
Lists artist's albums and tells iTunes to play the first song
from the specified album whose name starts with a vowel.
</span>
#! /usr/bin/env ruby
#
# usage: jukebox2.rb [artist-name] [album-name]
#
# Add some AppleScript to the jukebox so it can talk to
# iTunes. Lists artist's albums and tells iTunes to play the
# first song from the specified album whose name starts
# with a vowel.
#
# If artist-name or album-name are unspecified, default
# values (defined below) are used.

require 'osx/aeosa'
require 'jukebox1'            # The original jukebox code

# Here's the AppleScript we will use to gather song
# information.
LOAD_SCRIPT = &lt;&lt;EOF
set all_tracks to {}
tell application "iTunes"
  tell source "Library"
    tell playlist "Library"
      set the track_count to the count of tracks
      repeat with z from 1 to the track_count
        tell track z
          set all_tracks to all_tracks &amp; \{\{name, artist, album\}\}
        end tell
      end repeat
    end tell
  end tell
end tell
all_tracks
EOF

# Since class definitions never "close", we can easily
# define new methods or overwrite existing ones.

class Jukebox

  def load
    ret = OSX.do_osascript(LOAD_SCRIPT)
    all_tracks = ret.to_rbobj

    all_tracks.each { | track_ae |
        song_name, artist_name, album_name =
          track_ae.collect { | ae_obj | ae_obj.to_s }

        # See if we already have this artist in the
        # jukebox. If not, add it.
        artist = @artists[artist_name]
        if artist.nil?
          artist = Artist.new(artist_name)
          @artists[artist_name] = artist
        end

        # See if this artist already has this album.
        album = artist.albums[album_name]
        if album.nil?
          album = Album.new(album_name)
          artist.albums[album_name] = album
        end

        # Add the song to the album
        album.songs &lt;&lt; Song.new(song_name)
    }
  end

  def play(album, song)
    script = "tell application \"iTunes\"\n" +
      "tell source \"Library\"\n" +
      "tell playlist \"Library\"\n" +
      "play (tracks whose name is \"#{song.name}\"" +
      " and album is \"#{album.name}\")\n" +
      "end tell\n" +
      "end tell\n" +
      "end tell\n"
    OSX.do_osascript(script)
  end
end

# ==========================================================

# This code will only execute if this file is the file
# being run from the command line.
if $0 == __FILE__

  DEFAULT_ARTIST = 'Thomas Dolby'
  DEFAULT_ALBUM = 'Astronauts And Heretics'

  fave_artist_name = ARGV[0] || DEFAULT_ARTIST
  fave_album_name = ARGV[1] || DEFAULT_ALBUM

  jukebox = Jukebox.new
  jukebox.load()                # Use AppleScript

  # Print some stuff

  puts "All Artists:"
  puts "\t" + jukebox.artists.keys.join("\n\t")

  puts "#{fave_artist_name}'s albums:"
  artist = jukebox.artists[fave_artist_name]
  artist.albums.each_value { | album |
    puts "\t#{album.name}"
    puts "\t\t" + album.songs.join("\n\t\t")
  }

  puts "Play the first song from \"#{fave_album_name}\"" +
    " that start with a vowel"
  album = artist.albums[fave_album_name]

  # Make a new list by rejecting (skipping) songs that
  # do not start with a vowel.
  vowel_songs = album.songs.reject { | song |
    song.name =~ /^[^aeiou]/i
  }

  # Play the first song we found
  jukebox.play(album, vowel_songs[0])

end
</pre>

Finally, <a href="#listing11">Listing 11</a> lets your computer declare out
loud the name of its new favorite language.

<a id="listing11"/>
<pre class="code">
<span class="listing-title">Listing 11: speak.rb</span>

<span class="listing-summary">
Tell me: what's my favorite language?
</span>
#! /usr/bin/env ruby

require 'osx/cocoa'
include OSX

def speak(str)
  str.gsub!(/"/, '\"')        # Put backslash before quotes
  src = %(say "#{str}")
  # Call Objective-C code
  script = NSAppleScript.alloc.initWithSource(src)
  script.executeAndReturnError(nil)
end

speak "Ruby is my favorite language!"
</pre>

# Conculsion

I hope this article has given you enough of a taste of Ruby's features, power,
and elegance that you want to explore it more. Apple liked it enough to
include it with Jaguar. May you find it half as fun and useful as I have.

<a id="resources"/>
# Resources

## Books

Thomas, David and Andrew Hunt. <cite>Programming Ruby</cite>. Addison Wesley,
2001. This book, known also as "The Pickaxe Book" for its cover picture, was
the first English book on Ruby. It is an excellent tutorial and reference.
Published under the Open Publication License, the entire book is available
online. I highly recommend you buy a copy.

Matsumoto, Yukihuro. <cite>Ruby in a Nutshell</cite>. O'Reilly, 2002. This is
a "Desktop Quick Reference" based on Ruby 1.6.5.

Feldt, Robert, Lyle Johnson, Michael Neumann (Technical Editor). <cite>Ruby
Developer's Guide</cite>. Syngress, 2002.

Fulton, Hal. <cite>The Ruby Way</cite>. Sams, 2002.

## Internet Resources

The <a href="http://www.ruby-lang.org/en/">Ruby home page</a>. The <a
href="http://raa.ruby-lang.org/">Ruby Application Archive</a> (RAA) lives
there as well.

The Usenet news group <a href="news:comp.lang.ruby">comp.lang.ruby</a> and the
mailing list ruby-talk are synchronized (using Ruby code, of course).
comp.lang.ruby is where I go first if I can't find something in the manuals or
books. Matz or other expert Ruby programmers often answer questions there. See
the Ruby Web site for mailing list details. <a
href="http://www.ruby-talk.org">Ruby Talk</a> contains a searchable archive of
the list. The community of Ruby users is among the most friendly and helpful I
have seen.

<a href="http://www.rubycentral.com/">Ruby Central</a> is hosted by the
Pragmatic Programmers (Dave Thomas and Andy Hunt, authors of Programming
Ruby).

<a href="http://www.rubygarden.org">Ruby Garden</a> is an excellent collection
of Ruby news, links, polls, and is the home of the <a
href="http://www.rubygarden.org/wiki">Ruby Garden Wiki</a>. (A Wiki is a Web
site with user-editable pages. They're great for collaboration.)

William Tjokroaminata's Web page <a
href="http://www.glue.umd.edu/~billtj/ruby.html">Things that Newcomers to Ruby
Should Know</a> contains a number of tips for new Ruby programmers.

The <a href="http://jruby.sourceforge.net">JRuby project</a>. <a
href="http://datavision.sourceforge.net/">DataVision</a>, my database
reporting tool project, is written in Java but uses Ruby as its formula and
scripting language.

# About the author...

Jim Menard is a senior technologist with twenty years of experience in
development, design, and management. Like so many of us, Jim is an
ex-dot-com CTO and a consultant. A language maven, Jim loves everything
about Ruby. He has developed Open Source projects such as NQXML (the first
pure-Ruby XML parser), Rice, DataVision (a Java GUI report writer with Ruby
scripting), and TwICE. You can contact him at <a
href="mailto:jim@jimmenard.com">jim@jimmenard.com</a>.
