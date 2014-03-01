--- 
layout: post
title: Setting up Goals and Funnels - Google Analytics
tags: 
- Business
status: publish
type: post
published: true
comments: true
categories: [Analytics, Startup]
meta: 
  _edit_last: "1"
  _su_rich_snippet_type: none
  _su_keywords: Google, analytics, how, to, how to, tutorial, guide, funnel, metric, tracking, measure, startup
  dsq_thread_id: "248585411"
---
I had a recent request on how to setup a funnel in Google Analytics. If you've missed by first post on some tips for <a href="http://www.craigekerstiens.com/2011/02/02/events-with-google-analytics-and-tricking-pageviews/">Google Analytics</a> first check that out. With most websites today there is some portion of the site that is event and not page based, meaning you have some workflow on the page based on Javascript. If this is the case you'll want to <a href="http://www.craigekerstiens.com/2011/02/02/events-with-google-analytics-and-tricking-pageviews/">fake a page view</a> instead of an event in order to entirely use it in funnels and goals.

A personal recommendation is actually to use both, goals and funnels. The key a funnel is that you need to have successive steps that occur in some order. With regards to metrics tracking this is absolutely needed, but typically you may have 1-2 total funnels with many steps in your site versus goals where you could have 10-15 single goals. For <a href="http://www.registrystop.com">Registry Stop</a> we've structured our site so that our earlier stage goals become the same as steps in later stage funnels. For us in almost all cases the first part of the funnel is the visit, the second is registering for an account. We do have independent goals for visits and registrations as well, but we do not have funnels on those goals.

<!--more-->
A key to getting the most use out of your funnels is to know that there is a <strong>workflow to follow</strong> to getting to that end goal. To highlight this slightly more visually let me walk through an example:
<ol>
	<li><em><strong>User visits your site.</strong></em></li>
Here you'll want to create a goal. Likely this is tracking a page view of the homepage.
	<li><em><strong>User registers for an account.</strong></em></li>
Here again, you'll create a goal and nothing more. If there is a confirmation page that will be your goal, if there is not, then you'll want to <a href="http://www.craigekerstiens.com/2011/02/02/events-with-google-analytics-and-tricking-pageviews/">fake a page view</a> in order to track that goal.
	<li><em><strong>User adds a product</strong></em></li>
This is the first place you want to create both a goal and a funnel.</ol>
With regards to the goal, it should be pretty simple, tracking some page view. For the funnel though you will likely have 4 parts.

The parts of your funnel will be:
<ol>
	<li>User visits your site.</li>
	<li>User registers for an account.</li>
	<li>User begins process of adding a product</li>
	<li>User completes product add</li>
</ol>
For Registry Stop we have a similar funnel for users which includes:
<ol>
	<li>Registering for an account</li>
	<li>Visiting the sync page</li>
	<li>Adding a synced registry</li>
</ol>
Now as for actually setting up a goal or funnel. This is slightly unintuitive as it's not from inside a specific site on Google Analytics. At the home level of google analytics you'll have all of your sites setup. For each site to the right you'll have actions, click the Edit to go to the goal area.

<a href="/images/Snapz-Pro-XScreenSnapz011.png"><img class="alignnone size-full wp-image-348" title="Google Analytics Settings - Goals and Funnels" src="/images/Snapz-Pro-XScreenSnapz011.png" alt="Google Analytics Settings - Goals and Funnels" width="125" height="64" /></a>

Once here it becomes a bit more intuitive. You can begin by simply adding a goal. Your goal types should seem mostly intuitive, as mentioned in an earlier post you cannot use an Event in a goal. For this reason you can fake a pageview as if it actually occurred and then create your goal against that non-existent page view. If you want a few more details of how to do this check out the previous post . So for an example, we have a goal on <a href="http://www.registrystop.com">Registry Stop</a> that detects when a page view occurs as a result of a registry being synced. Because this workflow is heavily javascript and flow based we fake the page view and track it as if the page was actually visited. The goal itself looks like:

<a href="/images/Snapz-Pro-XScreenSnapz012.png"><img class="alignnone size-medium wp-image-350" title="Google Analytics Example Goal" src="/images/Snapz-Pro-XScreenSnapz012.png" alt="Google Analytics Example Goal" width="300" height="75" /></a>

For setting up your funnel as we mentioned above its generally a set of page views. A very key item is the check box next to the first item in your funnel. If you check this is means any other steps in the funnel are not counted unless you the first step is completed. If you have a very structured 1, 2, 3 workflow this makes sense. However, if there are various ways for the goal to complete then be very careful about selecting this.

For this same goal above we have a corresponding funnel to track in detail how our conversion flows. The funnel itself looks like this once setup:

<a href="/images/Snapz-Pro-XScreenSnapz022.png"><img class="alignnone size-medium wp-image-344" title="Google Analytics Funnel Setup" src="/images/Snapz-Pro-XScreenSnapz022.png" alt="Google Analytics Funnel Setup" width="300" height="127" /></a>

This results in a funnel report that looks like:

<a href="/images/Snapz-Pro-XScreenSnapz011.png"><img class="alignnone size-medium wp-image-342" title="Synced Registry Funnel" src="/images/Snapz-Pro-XScreenSnapz011.png" alt="Synced Registry Funnel" width="300" height="250" /></a>

&nbsp;
