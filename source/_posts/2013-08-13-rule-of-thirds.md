--- 
layout: post
title: The Rule of Thirds - followup
tags: 
- Heroku
categories: [Heroku]
type: post
published: true
comments: false
---

Several months back I wrote about how we do [higher level, long term planning within the Heroku Postgres team](http://www.craigkerstiens.com/2013/03/13/planning-and-prioritizing/). If you haven't read the previous article please start there. 

The exercise or rule of thirds is intended to be approximate prioritization and not a perfect science. Since that time I'm familiar with some teams both in and out of Heroku who have attempted this exercise with varying levels of success. We've now done this process 4 times within the team and after the most recent exercise attempted to take some time to internalize why its worked well, creating some more specifics about the process. Heres an attempt to provide even more clarity:

<!--more-->

## Gather data ahead of time

Its really common to have a list things to work on, but knowing the impact of those is commonly pure speculation. There may be some people that talk to customers, but even then its a subset of your actual customer base. Going into the exercise as much data you can have ahead of time on impact of features and specific problems helps. In our case we do this by:

1. Surveying current customers and users
2. Surveying attriters
3. Engaging with customer facing teams to hear trends
4. Input from external parties such as analysts on trends

## Allow for casual discussion

We typically conduct our planning exercise at an offsite, this is a multi-day time of team bonding, planning, hacking. We intentionally schedule our planning excercise towards the end of the offsite. This allows us to have updates/presentations frmo the data we've gathered and from those that are customer facing. Presentations are meant to be short and direct, discussion can flow casually after. This gets a lot of people on the same page at a smaller level and reduces the problem of too many cooks in the kitchen come time for the actual exercise.

## The rule of thirds

### Creating the list

Coming to the exercise itself... We begin by everyone writing a list of their ideas individually, this is meant to be a list of the features we want to place on the grid. At this point theres no prioritizing of difficulty or impact. In addition each list while individually created does not have to contain items that only pertain to you, its more a comprehensive list of all the things you can think of that may be important to do.

### Bucketing part 1

Once individual lists are created you can then collectively or designate one or two people to clean it up. We do this in two forms: 

1. Removing duplicate items, which there should be several of. 
2. Bucketing my a common/theme idea, this simply makes things more digestable
 
If you're a big group of greater than 7 then it may be advisable to designate two people to do this exercise together. If a smaller group it can be manageable to coordinate collectively.

### Bucketing part 2

Once you've removed dupes, identified themes, and removed excess items (depending on your team size you'll find how many feels right - we aim an average of 5-6 per square for a team of 10) its then on to actually putting them on the grid. In the past we've done this a variety of ways but our most recent process seemed to be quiet efficient. We gave each item 60 seconds, at the end of that minute wherever the item was it was left there. This forced some quick discussion on impact and difficulty but in the end left us at a very good hit rate without taking multiple hours to complete the exercise.

### Final pass

We intentionally design it so that low effort and high impact is on the top right corner. Finally once everything is on there we allocate names to the tasks, and put boxes around items we're planning to do in the coming months. With boxes make it very clear of what we are doing as well as explicitly things we are not. The initials or names make it clear of how loaded down people are. If your name is on 3 tasks that are high difficulty, then you're likely over allocated. 

At this point things usually fall out pretty quickly and we emerge with some rough roadmap that in retrospect we've followed pretty accuately.
