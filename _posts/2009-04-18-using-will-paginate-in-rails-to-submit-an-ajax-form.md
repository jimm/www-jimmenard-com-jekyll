---
layout: post
title: Using will_paginate in Rails to Submit an AJAX Form
tags: ajax rails ruby programming
---

I'm using [will_paginate](http://wiki.github.com/mislav/will_paginate) for a
Rails project. It works great, but I wanted to use it for a sidebar that
performs searches and displays the results. It's not too hard to write a
custom link renderer that will submit the will\_paginate link using Ajax, but
my situation was a bit different: I wanted will_paginate to inject the page
number into the search form and submit the form using Ajax.

Here's what I ended up doing: writing a link renderer that calls a
JavaScript function that injects the page number into the form and calls the
form's `onsubmit` function (which then submits the form using Ajax).

The code. First the Haml, which is in a partial that gets rendered on a
number of pages:

    
{% highlight haml %}
%h1 Asset Search
- form_remote_tag(:html => {:id => 'ssform', :name => 'ssform'}, ...) do
  %input{:type => 'hidden', :id => 'sspage', :name => 'sspage'}
  / ...
  %input{:type => 'submit', :value => 'Search'}

  - paginated_section(sidebar_assets, :class => 'rhs_pagination', :renderer => SidebarSearchLinkRenderer) do
    %table.list
    / ...
{% endhighlight %}

Next, the will_paginate renderer, in the file
`app/helpers/sidebar_search_link_renderer.rb`. The "#" is the href value,
and the onclick attribute calls a JavaScript funtion.

{% highlight ruby %}
class SidebarSearchLinkRenderer < WillPaginate::LinkRenderer

  def page_link(page, text, attributes = {})
    @template.link_to text, '#', attributes.merge(:onclick => "return sidebar_search(#{page});")
  end

end
{% endhighlight %}

Finally, the JavaScript function which I put in
`public/javascripts/application.js`:

{% highlight javascript %}
function sidebar_search(page) {
  $('sspage').value = page;
  document.forms['ssform'].onsubmit();
  return false;
}
{% endhighlight %}
