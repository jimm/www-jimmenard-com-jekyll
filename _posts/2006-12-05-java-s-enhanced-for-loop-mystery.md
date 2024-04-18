---
layout: post
title: Java's Enhanced For Loop Mystery
tags: programming java
---

I like Java 5's new enhanced for loop. It makes the code that iterates over
collections and arrays less verbose. Anything that reduces Java's verbosity
is a good thing in my book.

Yesterday I wondered if the Java 5 enhanced for loop calls the collection
expression once or every time through the loop. I searched for the answer
online, and couldn't find one. Every example I found assigned the collection
or array to a variable first and then used that variable in the expression,
like this:


{% highlight java %}
String[] list = {"a", "b", "c"};
for (String item : list) {
  // ...
}
{% endhighlight %}

What I was looking for was a statement like, "the list expression is only
evaluated once". After a few minutes, I realized that it would be faster to
write a small program to determine the answer. (See
[Just Try It](just-try-it.html).


{% highlight java %}
import java.util.*;

public class Test {

  public Collection<String> stringCollection() {
    System.out.println("I'm creating a new list now.");
    // Don't get me started on the verbosity of the next line...
    ArrayList<String> list = new ArrayList<String>();
    list.add("a");
    list.add("b");
    list.add("c");
    return list;
  }

  public static void main(String[] args) {
    Test t = new Test();
    for (String s : t.stringCollection())
      System.out.println(s);
  }
}
{% endhighlight %}

With a simple `javac Test.java && java Test` I had the answer:
`stringCollection()` is only called once.
