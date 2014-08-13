--- 
layout: post
title: When to ship it, when to kill it
tags: 
categories: []
type: post
published: true
comments: false
---

A few weeks ago at lunch I had the opportunity to catch up with a company in the current YC batch, building something very similar to dataclips. While we talked about a lot of things from what we've learned from dataclips, marketing, and other areas. One area we talked about was product and when to ship vs. when to kill things and I realized I hadn't talked on my fairly simple but clear view on this publicly, so here it is. 

*A large credit to [Adam Wiggins](http://www.twitter.com/hirodusk) for giving this model early on in Heroku and his approach to shipping product.* 

<!--more-->

### A precursor to shipping

First a little background on shipping, in shipping something I'm going to assume you have some process of alpha/beta testing with users. This is actually fairly key, if you're not testing it with users then well the rest of this is all moot. Alpha and beta testing is pretty simple, you need some early users. These can be friends, people within a network, or random users you select from. There's different value to how you select these but that's a topic for another time and place.

### On to shipping

So how do you know it's ready. The basic idea is super simple. Give it to some users in alpha/beta testing. Or start to roll it out following a one -> some -> many all principle (maybe to 5% or 10% of your userbase). Then take that brand new feature away.

There's a couple of ways to do this as far as mechanics. If you're in contact with users such as alpha/beta users that you were higher touch with just email them. Tell them you're removing the feature, or if you want to approach it more softly ask them how much they'd miss it if it were gone tomorrow. If you're rolling it out more broadly perhaps behind a feature flag, flip it off and watch for feedback. 


*Once you take the feature away or threaten to if you don't have users with pitchforks almost immediately then it's not ready to ship*. 

Go back to the drawing board and work more on it or simply kill it. As <a href="http://www.twitter.com/james_heroku">@james_heroku</a> would say: "So you're saying the reason to ship the shitty thing now is becase you've spent a lot of time on it?". Stepping back it's all logical, but all too often it's not put in practice when shipping it.


### Your metrics can lie

Relying on just seeing a user spend some time on the new feature can often be misleading vs. the above approach. There's a great talk by Des Traynor over at <a href="http://insideintercom.io/talk-product-strategy-saying/">intercom.io</a> that hits on this in part, the basic premise in there is that users shifting time from feature X to Y doesn't mean it was a success it just means they're spending time on something different. In launching new things you want to increase the overall value of your product, not simply shift users focus to the new flavor of the week. 