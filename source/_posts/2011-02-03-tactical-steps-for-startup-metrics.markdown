--- 
layout: post
title: Tactical Steps for Startup Metrics
wordpress_id: 208
comments: true
wordpress_url: http://www.craigekerstiens.com/?p=208
date: 2011-02-03 19:39:54 -08:00
comments: true
categories: [Analytics, Startup]
---
Metrics are obviously a very valuable area for start-ups, if you don't believe in metrics and think you're idea wins just because its great then you better start searching for your next day job. <a href="http://twitter.com/davemcclure">Dave McClure</a> has done a great talk on start-ups several times over, you can check out a video and corresponding slide show at:

<a href="http://www.ustream.tv/recorded/5336115">http://www.ustream.tv/recorded/5336115</a>
<a href="http://www.slideshare.net/dmc500hats/startup-metrics-for-pirates-long-version">http://www.slideshare.net/dmc500hats/startup-metrics-for-pirates-long-version</a>

And besides, it's a pirates acronym, so it's got to be great. But translating these from concept to actual technology metrics is also something that needs discussion. You can't exactly say we're going to use Google Analytics and let it magically tell you everything, furthermore all of the web developers out there talking about tweaks on Google Analytics do little to actually tell you what you need to know.

<!--more-->To start with I'm going to lay out a few of the key features of Google Analytics, assuming it's the key backbone for web analytics, and because it really is an amazing free tool.If you're not familiar with google analytics go and explore before reading this, we're going to skip right over the basics of what are visitors and traffic sources directly to what you need to use and customise to get valuable metrics for a start-up. Diving right in a few key items:

Goals - These are custom items that you want to setup. What is a goal? Well that can be a bit abstract but it can be a specific page that was visited, time spent on the site, or a certain number of pages per visit.

Events - Here you can start track events to any type of your liking. In most cases this can be some in page action, but the key here is to each event you can track a value. This starts to become useful if you want to track most shared content, most liked products, or other items. Typically those kinds of items might exist within your in-house database, but exposing it to Google Analytics gives you an extra level of reporting integration

Custom Reporting - Google is great out of the box, if you feel like it just grazes the surface then you haven't explored it. But in some cases it's easier to create a custom report of data that you can't get exactly to, or to get very quick insight into similar data.

So this is a really high level, but how do you use each of the above to tie to actually implementing the metrics you care about? We'll go through an example of how you track each of Dave McClure's 5 key metrics based. For those of you not familiar with his metrics, please go to the above links and listen to his presentation first.
<ol>
	<li>Acquisition, this one is pretty obvious. Google does this out of the box for you. The key reports you're likely to care about here are Visitors and Traffic Sources. You care about how many overall users you get and where they are coming from. If you're spending money on blog posts and its not getting visitors then give up on it. If you've barely focused on SEO, but are already getting organic traffic from google, well then WORK on SEO. One key thing you'll start to look into is when people bounce. Do they come from CPC ads and have an 90% bounce rate, if so they may click on the ad, but once they get to your site something turns them off. You're goal is to get users, and get them to explore the site.</li>
	<li>Activation, this one can start to vary pretty heavily. In this case lets assume you want a user to sign up for some form of free account. In some cases activation may be viewing a certain number of pages or certain set of pages, but often times capturing some information that you can track back to a user is key. This could be via facebook connect, a signup with email, or twitter. Regardless of what you consider an activation, likely one of the easiest ways to track this is with some form of a goal. If you have a fully javascript based process, more power to you, but it makes a specific page view a bit harder, but only slightly. Check our post on <a href="http://www.craigekerstiens.com/events-with-google-analytics-and-tricking-pageviews/">how to simulate a page view</a> along with how to track an event in google analytics. In this case you're goal might only be one step, in the case that several steps are required look into creating a funnel.</li>
1 and 2 are generally straightforward. You get a user to the sight and you get one to sign up. So what? Well keep going....
	<li>Retention, you need a user to come back. If you're going to make money someone has to keep coming back, unless you're damn good at sales, you're not going to sell them a penny on the first visit for $100. You need them to establish some brand recognition and continue to come back to you. Sure google will easily tell you how many are new visitors and how many are return, but this is only minimally helpful. What's bringing back return users, is it your blog posts, twitter, email campaigns. The best way to track what's keeping your users coming back is likely a custom report. This way you can check your traffic sources, along with which users are return visitors. What you likely want to drill down into from the first level is which content your users are visiting. Is what you feel a key feature not being used from a certain source? Is it an issue of marketing or not a valuable feature? Dave McClure has a recent idea of kill it, and see if users yell, this is definitely one way to tell if its useful. It's probably easiest to create a report to start with and see what's the usage of pages/content.</li>
	<li>Referral, very possibly this is the hardest to track. In our case we track it in several forms. First is that someone is sharing something, this could be via twitter/fb/email. Since most sites are building some form of social sharing directly into their applications. It can be a bit hard to tell which part of a referral users engage and abandon in. We recommend a couple of options here, the first is tracking events. Events truly exist for just this purpose, tracking various events. In this case you might track events based on a category of referral, and separate events being:
<ul>
	<li>Email</li>
	<li>Twitter</li>
	<li>FB</li>
</ul>
With values being
<ul>
	<li>Shared</li>
	<li>Abandoned</li>
</ul>
</li>
Overall you can have a good bit of flexibility with events, but the hard part is reporting against them. If you want numeric values tracked events are the way to go, but if its a straight forward process, then you may want to simulate a page view at each step. The reason for this is that you could then great a goal, which has a full funnel to it. Funnels are very helpful at being able to visualise how many users proceed to the next step in a goal. In our example of visiting a page, selecting a method to share, authenticating, and sharing, its clear that every step must be taken. If you can structure your goals this way by all means create a funnel. If not, simple goal or event tracking can suffice.
	<li>Revenue, of course it comes down to money in the bank at the end of the day. Here events are almost inevitable, especially if you can tie an exact amount to your revenue. If however there's a set amount of revenue based on either the ads or based on the type of account a user registers for. If you have the ability to make this a page view then go for it, such as by 3 account levels. In most cases though what you'll care about it is the exact revenue you can make, if you can't tied this to a category or account level, tie it directly to the event. Events, as mentioned above, let you tie an exact value to the event. Of course you could easily compute revenue from your in house reporting system, but the ability to tie revenue to other metrics/dimensions is where you get your real value.</li>
</ol>
