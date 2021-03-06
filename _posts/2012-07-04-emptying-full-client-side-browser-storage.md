---
layout: post
title: Emptying Full Client-Side Browser Storage
---

This morning I started seeing the following error on all preview pages
generated by an app running on my development machine:

{% highlight text %}
QUOTA_EXCEEDED_ERR: DOM EXCEPTION 22
in http://localhost:8080/sites/1341373150.915000/public_html/layout.less
{% endhighlight %}

This error message isn't caused by the application, it's because the
generated HTML uses client-side LESS to render its CSS. The LESS processing
had filled up local storage, because each preview generates new storage keys
due to the ever-changing timestamp part of the URL.

The solution: here's how to manually clear your browser's local storage of
any data whose keys match a particular value:

{% highlight javascript %}
// Clears local storage of keys that match a regular expression.
function clear_local_storage(key_regexp, keep_key=null) {
  var r = new RegExp(key_regexp);
  for (var key in localStorage) {
    if (key != keep_key && r.test(key))
      localStorage.removeItem(key);
  }
}
{% endhighlight %}

A sample of its use:

{% highlight javascript %}
clear_local_storage("^http://localhost:8080/sites.*layout.less(:timestamp)?$");
{% endhighlight %}


Since I wrote the app that's publishing the pages that generate this error,
I'm considering making the app inject this JavaScript code into the pages to
make sure that end users never see this error message.
