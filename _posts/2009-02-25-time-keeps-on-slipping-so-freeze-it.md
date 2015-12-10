---
layout: post
title: Time Keeps On Slipping, So Freeze It
tags: testing, ruby, programming
---

A friend of a friend has
[trouble testing timestamps](http://yonkeltron.com/2009/02/25/trouble-testing-timestamps/).
I tried replying there, but don't think my answer got through so here it is.

The short answer: all time operations should not use the wall clock, but a
system time object that you create. In production, the system time object
returns wall clock time. In testing, you replace/mock/modify it so that it
uses the time you give it. In other words, it becomes a clock that you can
freeze and re-set whenever you need to.

Here is an example SystemClock class in Ruby. All of your classes should use
this class to get the current date and time instead of using the Time or
Date classes directly.

{% highlight ruby %}
# Keeper of the current system time. This class is sometimes overridden
# during testing to return different times.
class SystemClock

  def self.date
    Date.today
  end

  def self.time
    Time.new
  end

end
{% endhighlight %}


Here is the mock used during testing. You can set the time using this mock
object and it will not change until it is set again.

{% highlight ruby %}
# This mock lets you set the system date and time during testing. For
# example, to set the date to tomorrow,
#
# A few examples of use:
#
#   SystemClock.date = Date.today + 1 # Time also set: to tomorrow 9:10:11 am
#   SystemClock.date = nil            # Go back to using system date and time
#   SystemClock.date = Date.civil(2006, 4, 15)
#   SystemClock.time = Time.local(2006, 3, 2, 8, 42, 42) # Date changed, too
#
# When you set the date, the time is set to 9:10:11 am of the same day,
# local time. When you set the time, the date is set to the same day.

require 'models/system_clock'

class SystemClock

  @mock_date = nil
  @mock_time = nil

  def self.reset
    @mock_date = nil
    @mock_time = nil
  end

  def self.date=(date)
    @mock_date = date
    @mock_time = date == nil ? nil :
      Time.local(date.year, date.month, date.day, 9, 10, 11)
  end

  def self.time=(time)
    @mock_time = time
    @mock_date = time == nil ? nil :
      Date.civil(time.year, time.month, time.day)
  end

  def self.date
    @mock_date || Date.today
  end

  def self.time
    @mock_time || Time.new
  end

end
{% endhighlight %}

So in your normal production code you get the current time by calling
=SystemClock.time= instead of =Time.now=. In your test code, you'd do
something like this:

{% highlight ruby %}
# Make sure to include the mock class
SystemClock.time = Time.now # Or any arbitrary time
thing = Thing.new           # Uses SystemClock to set created_at attribute
assert_equal SystemClock.time, thing.created_at
{% endhighlight %}
