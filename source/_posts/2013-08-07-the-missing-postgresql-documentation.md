--- 
layout: post
title: The missing PostgreSQL documentation
tags: 
- Postgres, SQL, PostgreSQL
categories: [Postgres, SQL, PostgreSQL]
type: post
published: true
comments: false
---

For a couple of years I've complained about the Postgres documentation and at the same time paraded it as one of the best sets of documentation I've encountered. In many ways the reason I veer towards [Postgres](http://www.postgresql.org) as well as [Python](http://www.python.org) and [Django](http://www.djangoproject.com) is the quality of their documentation. If you need to find details about something its documented, and more importantly well and thoroughly documented. 

In large part I came to Python by happenstance through [Django](http://www.djangoproject.com), and Postgres through happenstance of an employer. Yet, Django was very little of an accident. The Django Tutorial got me a large part of what I needed to know and more excited about development than I had been in some time. Python has done some work at adding docs to make this even better, sadly its still very much needed for PostgreSQL. 

<!--more-->

### Whats Missing in the Postgres Docs

Theres a huge variety of types of documentation, off the top of my head theres:

* Reference docs (Postgres excels at this)
* Onboarding (Postgres tutorial huh?)
* Tailored guides (Postgres? I can haz? Nope... We don't understand....)

Postgres is great if you know the name of what you're looking for, but if you don't you're entirely left in the dark. 

### Understanding the power of Postgres

Postgres is good enough at performance, good enough at usability, and awesome at how powerful and flexible it can be. But all of this is entirely lost if you have to know the esoteric name of what you're looking for. 

*What the hell is an hstore... In so many ways KVstore makes infintely more sense. In the same sense PLV8, I have to know not only what PL stands for but V8 as well, versus the JavaScript extension for Postgres.* 

I understand there are plenty of reasons why some of these things are the way they are, but its also limiting how great the broader perception is. Postgres externally is this hard to use DB, that well is just a database, versus giving developers a set of powerful and useful functions to make their lives better.

### The Solution

Lets fix things, there are a ton of people that would love to know more about all things Postgres. This ranges from a good set of onboarding docs, to specific blog posts on topics that people are curious about. Just last week I got an email about improving **the** Postgres tutorial... Yes theres a tutorial hidden in the [2000 page set of documentation for Postgres](http://www.postgresql.org/docs/9.2/static/tutorial.html). Its simply old, mostly uninteresting, and well just needs to be completely recreated. A great alternative would be a few tutorials/guides for:

* Noobs to databases in general (Total 101 guide)
* Building and architecting your application with Postgres (App Devs)
* Administering and maintaining Postgres (DBAs)
* SQL and reporting in Postgres (consumers of data, analysts, product people, marketing, etc.)

If jumping in and contributing to fixing the core tutorial isn't your cup of tea because you don't want to learn and write in [SGML](http://www-sul.stanford.edu/tools/tutorials/html2.0/gentle.html), send a pull request to [postgresguide.com](http://postgresguide.com) or do a [guest post on my blog](mailto:craig.kerstiens@gmail.com]. If thats too much effort please just let us know, what do you want to see - [craig.kerstiens at gmail.com](mailto:craig.kerstiens@gmail.com)