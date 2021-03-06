--- 
layout: post
title: What being a PM is really like - Software is easy, People are hard
tags: Startups, Product Management
categories: [Startups, Product Management]
type: post
published: true
comments: false
---

In recent months I've had the question nearly once a week about advice/tips for becoming a Product Manager or more commonly referred to as PM. These are generally coming from people that are either currently engineers, or previously were and are in some engineer/customer role such as a sales engineer or solution architect. There's a number of [high level](http://www.amazon.com/Inspired-Create-Products-Customers-Love/dp/0981690408?tag=mypred-20) pieces talking about PM and it often feels glorious, I mean you get to make product decisions right? You get to call some shots. Well that sometimes may be true, but don't assume it's all rainbows and sparkles. 

Especially as a first time PM what your day to day will look like won't be debating strategy all day long. Here's a few of the good and the bad sides of being a PM.

<!--more-->

### Plenty of grunt work

While you may get to make a decision or two, the bulk of your time will not be thinking about grandiose visions, instead you'll be doing a lot to gather data. There's a lot of means for gathering data across lots of sources, the more you use the better you'll be. Knowing the ones you steer towards, as well as ones you steer away from is useful so you can balance a bias more fairly. For myself SQL is a go-to, then customer interactions both qualitative and quantitative such as surveys, following what media is saying about your space is important as well. And while user studies are often relegated to design and UX, as a PM you need to make sure it at least happens ([Invision App](http://www.invisionapp.com/) is a favorite for lightweight tests).

In a given week I probably spend 10 hrs interacting with customers, looking at data, and sadly that's probably not enough. 

*A few practical examples of this*

Each morning I send emails to 10-20 users who used the product for the first time, yes this is automated but carving out 30 minutes of my day to actually follow-up with each of them is less automated. 

Another example is keeping a health of business dashboard up to date. Personally I use google sheets for this. Within one spreadsheet I have monthly and weekly targets as well as how we’re tracking against them. These are all updated on actual real time data, powered by Heroku’s dataclips with a simple `=importCSV(‘http://dataclips.heroku.com/abcdefghij….csv’)`. In total my google spreadsheets has 1 high level overview, with about 20 underlying sheets that do all of the computations. In any given month 1 of my key 4-5 goals may be missed, which then spawns digging in deeper to figure out why and what we can do about it.

### Dictating vs. consensus

From a product decision making perspective you can force alignment by explicitly making every decision, or you can allow decisions to be made as a group voting if needed. Expect to use some balance of both of these among the team, and neither is never perfect. When it comes to outside the team you may still use both, but steer more strongly one way or the other. For example with the executive team it may be more consensus, with marketing it may be dictating your product roadmap which they can help support. 

Even within the team there will be times a decision must be made and there will be some people that don't align. It's key that you make the decision clearly and explicitly. Even though some individuals don't like it, they won't fight against it... unless you make a habit of taking the input, then discarding it and going along your 'intuition'. Even when there's a strong case based on the data it may not be as clear as you think.

In contrast, decision making by consensus most people will feel happier that they provided input into the product. If you take everyone's input expect to end up with a product that feels like 10 people designed it, needless to say incoherent. 

As a PM expect to do a lot of listening, a good bit of convincing, and some occasional big decision making. 

### The pain you feel inside the building doesn't matter

You may think you're solving a problem that exists for users, when in reality there was no problem at all. This is just a reminder that you need to keep empathy in mind above so much else. 

As an example, once a data team put in place a tool, supposedly for me. I looked at the tool and more or less didn't understand why it was in place. They proceeded to explain that my problem was it took me too long to write SQL, so this tool will help me get the reports I need without SQL. At that point I proceeded to actually list off all the issues I did have, none of which [were SQL](http://www.craigkerstiens.com/categories/postgres/). 

Prescribing a solution without knowing clearly **from customers** what the problem is will leave you in a bad spot. All this means you have to set aside building the tool you want to use, and make sure you know what the [customer wants](http://headrush.typepad.com/creating_passionate_users/2005/01/keeping_users_e.html). 

### Marketing is your job

Not external marketing, though often that work may still fall to you, but rather internal marketing. 

It’s important that you internally market the wins for your *team*. These wins should very much be for the team, and not for your own benefit. The best PMs seem to disappear into the background, this is because you’re more surfacing all the work your team is doing than any of the details you helped coordinate. This is often counter to our natural instinct to tout our own accomplishments. This is only exaggerated in PM role, one where things can still ship if you’re not there, so there can often be a tendency to try to highlight the roles value. Fight that urge to self market.

<img src="https://s3.amazonaws.com/f.cl.ly/items/412j330z173E1d432M05/Untitled.png?v=4ceec9d2" style="float:right; width:50%; margin-left:20px;" />

Rest assured though–getting the team focused on solving the right problems, and then surfacing their wins will only help you go faster.  

### On leading

<img src="https://s3.amazonaws.com/f.cl.ly/items/3E2c3k1p1j2g2O1O0b0L/Untitled.png?v=9daf9e58" style="float:right; width:50%; margin-left:20px;margin-bottom:15px;" />
You’ll have to lead at times, follow at others, and all of this will likely be with no reports. Don’t confuse a lack of engineers reporting to you (which they should not, a common team structure can be seen on the right) for not needing to lead the team at times. *For those less familiar it’s very rare for a PM to have engineers report to them, though occasionally designers will. It’s typically the cross-reporting structure you’ll find talked about by Andy Grove in [High output management](http://www.amazon.com/High-Output-Management-Andrew-Grove/dp/0679762884?tag=mypred-20).* If the team is firing on all cylinders, knows the direction, and executing then step back and let things roll forward. If that’s not the case and leadership around direction or otherwise is needed be prepared to step up. 

At the end of the day ensuring the product is advancing is your job, so be prepared to do what you need to whether it’s leading or not to accomplish that.

### It’s not all rainbows, but it is fun

The range of things you’ll have to focus on can be diverse and complex. In the end if you get a rush out of shipping and launching products, then all the work that goes into it can make it all worthwhile. It’s as much about figuring out what customers want and then getting your team building the right thing. For a first time PM it can be summed up by the notion that software is easy, people are hard. 

*Special thanks to [Lukas Fittl](http://www.twitter.com/lukasfittl) and [Arun Thampi](http://www.twitter.com/iamclovin) for reviews and feedback on this post.*

