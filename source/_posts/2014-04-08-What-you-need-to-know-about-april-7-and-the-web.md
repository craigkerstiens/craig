--- 
layout: post
title: What you need to know about April 7 and your security on the web.
tags: 
- Technology
categories: [Technology]
type: post
published: true
comments: false
---

<img src="http://heartbleed.com/heartbleed.png" style="float:right;margin-left:20px;height:300px;"/>
On April 7 a vulnerability, nicknamed heartbleed, was discovered in a programming library that helps power somewhere over half of the internet. In the most basic sense this library allowed intentional external parties to acquire data that was thought to be safe and secure from whomever was running a vulnerable website. There was little to know one that was except from this due to their security practices, major examples of sites that were affected include:

* Yahoo 
* Amazon.com
* Netflix
* Various banks
* Many more

If you're interested in more technical details you can [follow along](http://www.heartbleed.com) or on the [Heroku blog](https://blog.heroku.com/archives/2014/4/8/openssl_heartbleed_security_update). 

The short of it is you, yes you as in everyone, should rotate your passwords once all websites are safe. For further details please continue reading.

<!--more-->

### What does the vulnerability mean

<img src="https://pbs.twimg.com/media/Bks0vXLIUAAaexR.jpg" style="float:right;margin-left:10px;"/> In this case it allowed an external party to acquire a moderate amount of data from some computer running your website. Extremely clear examples (such as shown on the right) highlight an example of random third parties easily acquiring most recently logged in Yahoo mail usernames and passwords.

### The first step

The first step in resolving this is actually not a step required by you at all, unless you're running a production website online. The first step requires the developers running the site to update their site so they are no longer vulnerable. This as available to happen as early as April 7, and many major sites were fully updated and again safe as of April 8.

### Still area for concern

With security vulnerabilities there are two key things to consider. First is the vulnerability itself, second is whether its therotical or can be simply acted upon. Yes, there's a range here. One of the most unfortunate pieces from talking to those that know about security is this was extremely trivial to act upon.

*This is made even worse in that this vulnerability has existed for 2 years without many knowing about it, meaning people have had an ability to snoop and collect parts of your data for two years*

### What to do?

First things first, be extremely cautious with any major website you connect with anything important. Any account that you have a password and you care about the account you should cease logging into it **until you know its safe**. As of the morning of April 8 here is a [list of sites that were safe and ones that were vulnerable](https://gist.github.com/dberkholz/10169691). You can check any site today [here](http://filippo.io/Heartbleed/). 

Once it's clear that a site you know is now updated and safe either via that list of the latter tool you should change your password. For the time that this has existed and ease of comprimising its safe to assume all of your internet passwords and data within those accounts could have been comprimised. This means any website you have logged into within the last two years you should change the password for. Changing your passwords limits anyone being able to access that again.


*I am not a security expert or analyst, but have heavily interacted with many that are in dealing with this incident. This advice is high level intended at non technical experts, if you have any questions or feedback please let me know on twitter [@craigkerstiens](http://www.twitter.com/craigkerstiens)*