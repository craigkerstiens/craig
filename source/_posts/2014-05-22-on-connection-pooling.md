--- 
layout: post
title: Postgres and Connection Pooling
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

Connection pooling is quickly becoming one of the more frequent questions I hear. So here's a primer on it. If there's enough demand I'll follow up a bit further with some detail on specific Postgres connection poolers and setting them up.

### The basics

For those unfamiliar, a connection pool is a group of database connections sitting around that are waiting to be handed out and used. This means when a request comes in a connection is already there whether in your framework or some other pooling process, and then given to your application for that specific request or transaction.  In contrast, without any connection pooling your application will have to reach out to your database to establish a connection. While in the most basic sense you may thinking connecting to a database is quick, often theres [some overhead here](/2013/03/07/Fixing-django-db-connections/). An example is SSL negotiation that may have to occur which means you're looking at not 1-2 ms but often closer to 30-50. 

<!--more-->

### The options

There's really two major options when it comes to connection pooling:

* Framework pooling
* Standalone pooler
* *Persistent connections* 

#### Framework pooling

Today many modern application frameworks have at least some basic level of connection pooling. This means as your application server starts up it will create a pool of connections to use. It's worth noting that while most modern frameworks have pooling, not all do, and further it may not be enabled by default. 

If you're using the Sequel ORM for Ruby or SQLAlchemy for Python you're well covered here. Further [Rails](https://devcenter.heroku.com/articles/concurrency-and-database-connections) is in pretty good shape also, though you may want to configure the pool size. For Django it's a bit of a mixed story. For some time [Django](/2013/03/07/Fixing-django-db-connections/) did not have pooling at all. As of Django 1.6 you now have persistent connections by default and the ability to enable a pool. 

#### Persistent connections

Persistent connections don't offer all of the benefits of pooling, but can often work well enough. Persistent connections is the act of maintaining a connection to your database once it's connected. In the case where you have overhead of 30-50 ms each time you connect this can be quite helpful. At the same time you're limited to the number of things that can be interacting with your databases as you're limited to 1 connection per entry point to your webserver. 

#### Standalone pooling

Postgres can be a bit of a sore spot when it comes to handling a ton of connections. For Postgres each connection you have to your database assumes some overhead of memory. Casual observations have seen it be between 5 and 10 MB assuming some basic query workload. And even if you have the memory overhead on your Postgres instance there becomes a point where management of connections becomes a limiting factor, we've seen this somewhere in the hundreds. While framework level connection poolers can give soem better performance and lenthen the time before you have to deal with something more complex if you're successful that time may come. 

*A rule of thumb I'd use is if you have over 100 connections you want to look at something more robust*

In this case that something more robust is a standalone pooler specifically for Postgres. A standalone pooler can be much more configurable overall letting you specify how it works for Postgres sessions, transactions, or statements. Further these are very specifically designed to work with Postgres handling a very large pool of connections without adding too much overhead. In contrast to the 5MB-ish standard connection to Postgres PG Bouncer has a 2kb per connection. 

So once you're at the point of needing one there's really two options. 

1. [PG Bouncer]()
2. [PG Pool](http://www.pgpool.net/mediawiki/index.php/Main_Page)


### PG Bouncer

My short and sweet recomendation is towards PG Bouncer. Contrary to how it's named PG Pool is a multi purpose tool that does a lot of things (pooling, load balancing, replication, more). PG Bouncer takes the philosophy of doing one thing and doing it extremely well. I tend to favor these types of tools, which is the same reason I lean towards [WAL-E](https://github.com/wal-e/wal-e) to help with Postgres replication.

### Need more?

Need more guidance with setting up and running PGBouncer? Give this [guide](http://datachomp.com/archives/getting-started-with-pgbouncer/) a look or try the [pgbouncer buildpack](https://github.com/gregburek/heroku-buildpack-pgbouncer) if running on Heroku. If you're still interested in a deeper guide let me know [@craigkerstiens](http://www.twitter.com/craigkerstiens) and I'll work on getting it into the queue.
