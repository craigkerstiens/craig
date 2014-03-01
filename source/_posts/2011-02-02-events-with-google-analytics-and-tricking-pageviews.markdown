--- 
layout: post
title: Events with Google Analytics and Tricking Pageviews
wordpress_id: 205
comments: true
wordpress_url: http://www.craigekerstiens.com/?p=205
date: 2011-02-02 16:28:56 -08:00
comments: true
---
Google analytics is great out of the box, the basic tracking tag on every page will do a lot for you. Unfortunately most people never get beyond this. There are two key items with tracking that you can do that will let you get a bit further. There's also plenty more on the reporting side, but we'll get to some of that later. On the tracking side the first item is event tracking. This is perhaps most commonly used for tracking various Javascript events that occur during a visit, however it can also be a bit more flexible towards tracking values. A very simple example might be:
<pre>_ga._trackEvent(category, action, opt_label, opt_value)</pre>
Or a real life example of this, might be on a FAQ screen, clicking the link to an anchored section of the page:
<pre>_ga._trackEvent('faq', 'anchor click', $(this))</pre>
But events by their sheer nature give a bit more flexibility with that value field. In the case of a user sending a message <!--more-->
you might be able to track how many recipients it has, or any other numeric value you want to track.

Events overall are great, but you're limited to the set Google Analytics report to know whats happening with them. So much of Google Analytics is based around page views, fortunately Google makes it easy to entirely fake a page view. If you're wondering why you'd care whether it's a page view versus events, we'll get to that in a later post. For now what's important to know is that you can fake any page view with:
<code>_gaq.push(['_trackPageview', '/somepagenamehere]);</code>

While seemingly small tweaks and extra additions these two items will create massive value for what you can actually do with Google Analytics. Stayed tuned later for how you use these with the base Google Analytics to actually get the value.
