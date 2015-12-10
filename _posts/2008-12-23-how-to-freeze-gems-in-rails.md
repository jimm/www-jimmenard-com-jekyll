---
layout: post
title: How To Freeze Gems In Rails
tags: rails, ruby, programming
---

Here's how to freeze any gem into your Rails app. This is a simplified
version of the larger discussion
[Vendor Everything](http://errtheblog.com/posts/50-vendor-everything) at
err.the_blog.

First, copy the gems you want into the directory vendor/gems.

{% highlight bash %}
mkdir vendor/gems
cd vendor/gems
gem unpack some_gem_name # repeat for each gem
{% endhighlight %}

Next, edit config/environment.rb and add the following inside the
=Rails::Initializer.run= block:

{% highlight ruby %}
Rails::Initializer.run do |config|
  # add the next three lines
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir|
    File.directory?(lib = "#{dir}/lib") ? lib : dir
 end
end
{% endhighlight %}


Now you can require those gems in your code, even if the system you are
running on doesn't have that gem installed.
