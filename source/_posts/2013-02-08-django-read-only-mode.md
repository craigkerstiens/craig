--- 
layout: post
title:  Introducing django-db-tools
tags: 
- Dataclips
categories: [Django, Database, Python]
type: post
published: true
comments: false
---

For any successful web application there is likely to come a time when you need to conduct some large migration on the backend. I dont mean simple add a [column here or add an index there](http://www.craigkerstiens.com/2012/05/07/why-postgres-part-2/), but rather truly sizeable migrations... Going from [MySQL to Postgres](http://lanyrd.com/blog/2012/lanyrds-big-move/) or migrating from an older version of Postgres such as a [32 bit instance](http://blog.sendhub.com/post/30041247598/how-to-upgrade-a-legacy-heroku-database) to a newer 64 bit instance. In these cases the default approach is to just schedule downtime often throwing up a splash screen saying so. 

For many sites this approach is simply wrong and lazy, with little effort you can improve the experience and there by ease the burden in conducting these types of migrations. By having the ability to turn your site into a read only mode which [Simon Wilson](http://twitter.com/simonw) talked about in his post on Lanyrd you can still continue to operate just in a limited capacity. [Andrew Godwin](http://www.aeracode.org/2012/11/13/one-change-not-enough/) further talks about some of this as well in regards to the Lanyrd move and even includes  the script they used to [migrate data from MySQL to Postgres](https://github.com/lanyrd/mysql-postgresql-converter/). Though just in talking with Simon about this a week ago it occurred to me they had not released the code for their read-only mode. 

Finally onto the announcing, today I'm releasing [django-db-tools](https://github.com/craigkerstiens/django-db-tools). This is currently a very lightweight utility that allows you to flip your site into two modes. 

<!--more-->

### Anonymous Mode

For sites that offer a bulk of their data to unauthenticated users anonymous mode will be what you want. This ensures all users appear logged out and thus cannot interact with data. To enable anonymous mode you'd simple set the environment variable or config var on heroku as follows:

    READ_ONLY_MODE = True

### Restricting POSTs

The other bucket of sites is one that allows users to stay logged in but not insert data. Django did not appear to have a convenient means to know whether data was actually being inserted into the DB or not. As a good practice when inserting data it should be receiving a HTTP POST. The `GET_ONLY_MODE` mimmicks all POSTs as if they were sent via GETs thus hopefully eliminating inserting data into your application. To turn it on simply set the environment variabel or config var on heroku to:

    GET_ONLY_MODE = True

### Installing

The tool itself is largely middleware, to install:

1. Run `pip install django-db-tools` or add it to your `requirements.txt`
2. Add `db_tools` to your `INSTALLED_APPS` in your `settings.py`
3. Add `'dbtools.middleware.ReadOnlyMiddleware',` to your `MIDDLEWARE_CLASSES` in `settings.py`
 
### Contributing

As with all code this is largely a work in progress. There's many items still to do such as providing default copy and error pages and potentially handling other edge cases. I'd welcome others to contribute and give feedback if they find it helpful or how it can be improved on Github.