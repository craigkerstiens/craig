--- 
layout: post
title: "Why use Postgres (Updated for last 5 years)"
tags: Postgres, PostgreSQL
categories: Postgres, PostgreSQL
type: post
published: true
comments: false
syndicate_to_planet: true
---

Five years ago [I wrote a post](http://www.craigkerstiens.com/2012/04/30/why-postgres/) that got some good attention on why you should use Postgres. Almost a year later I [added a bunch of things](http://www.craigkerstiens.com/2012/05/07/why-postgres-part-2/) I missed. Many of those items bear repeating, and I'll recap a few of those in the latter half of this post. But in the last 4-5 years there's been a lot of improvements and more reasons added to the list of why you should use Postgres. Here's the rundown of the things that make Postgres a great database you should consider using. <!--more-->

### Datatypes, including JSONB and range types

Postgres has long had an open and friendly attitude for adding datatypes. It's had arrays, geospatical and more for some time. A few years ago it got two datatypes worth thinking about using:

#### JSONB

JSONB is a binary representation of JSON. It's capable of being indexed on with `GIN` and `GIST` index types. You can also query into your full JSON document for quick lookups. 

#### Range types

While it didn't arrive to the same fame as JSONB, [range types](https://wiki.postgresql.org/images/7/73/Range-types-pgopen-2012.pdf) can be especially handy if they're what you need. Within a single column you can have a range from one value to another–this is especially helpful for time ranges. If you're building a calendaring application or often have a from and to of timestamps then range types can let you put that in a single column. The real benefit is that you can then have constraints that certain time stamps can't overlap or other constraints that may make sense for your application.

### Extensions

It'd be hard to talk about Postgres without all the ecosystem around it. Extensions are increasingly quite key when it comes to the community and growth of Postgres. Extensions allow you to hook into Postgres very natively without requiring them to be committed back to the core of Postgres. This means they can add rich functionality without being tied to a Postgres release and review cycle. Some great examples of this are:

#### Citus

[Citus](https://www.citusdata.com) (who I work for) turns Postgres into a distributed database allowing you to easily shard your database across multiple nodes. To your application it still looks like a single database, but then under the covers it's spread across multiple physical machines and Postgres instances.

#### HyperLogLog

This is a personal favorite of mine that allows you to easily have close-enough distinct counts pre-aggregated, but then also do various operations on them across days such as unions, intersections, and more. [HyperLogLog and other sketch algorithms](https://www.citusdata.com/blog/2017/04/04/distributed_count_distinct_with_postgresql/) can be extremely common across large datasets and distributed systems, but it's especially exciting to find them pretty close to out of the box in Postgres.


#### PostGIS

PostGIS isn't new, but it's worth highlighting again. It's commonly regarded as the most advanced geospatial database. PostGIS adds new advanced geospatial datatypes, operators, and makes it easy to do many of the location based activities you need if you're dealing with mapping or routing.

### Logical replication

For many years the biggest knock against Postgres was the difficulty in setting up replication. Originally this was any form of replication, but then streaming replication came along (this is streaming of the binary WAL or write-ahead-log format). Tools like [wal-e](https://github.com/wal-e/wal-e) help leverage much of the Postgres mechanisms for things like disaster recovery. 

Then we had the foundation for logical replication in recent releases, though it still required an [extension](https://github.com/2ndQuadrant/pglogical) to Postgres so it wasn't 100% out of the box. And, then finally we got full logical replication. Logical replication allows the sending of more or less actual commands, this means you could replicate only certain commands or certain tables. 

### Scale

In addition to all of the usability featuers we've seen Postgres continue to get better and better at [performance](https://www.slideshare.net/fuzzycz/postgresql-performance-improvements-in-95-and-96). In particular we now have the foundations for [parallelism](https://www.postgresql.org/docs/current/static/parallel-query.html) and on some queries you'll see much better performance. Then if you need even greater scale than single node Postgres (such as 122 or 244 GB of RAM on RDS or Heroku) you have options like [Citus](https://www.citusdata.com) which was mentioned earlier that can help you scale out. 

### Richer indexing

Postgres already had some pretty powerful indexing before with [GIN and GiST](https://www.postgresql.org/docs/9.5/static/textsearch-indexes.html), those are now useful for JSONB. But we've also seen the arrival of KNN indexes and Sp-GiST and have even more on the way. 

### Upsert

Upsert was a work in progress for several years. It was one of those features that most people hacked around with [CTEs](http://www.craigkerstiens.com/2013/11/18/best-postgres-feature-youre-not-using/), but that could create race conditions. It was also one of the few features MySQL had over Postgres. And just over a year ago we got [official upsert](http://www.craigkerstiens.com/2015/05/08/upsert-lands-in-postgres-9.5/) support.

### Foreign Data Wrappers

Okay, yes foreign data wrappers did exist many years ago. If you're not familiar with foreign data wrappers, they allow you map an external data system to tables directly in Postgres. This means could could for example interact and query your [Redis](http://www.craigkerstiens.com/2012/10/18/connecting_to_redis_from_postgres/) database from directly in Postgres with SQL. They've continued to be improved more and more from what we had over 5 years ago. In particular we got support for write-able foreign data wrappers, meaning you can write data to other systems from directly in Postgres. There's also now an official Postgres FDW which comes out of the box with Postgres and it by itself is quite useful when querying across various Postgres instances.

### Much more

And if you missed the [earlier editions](http://www.craigkerstiens.com/2012/04/30/why-postgres/) of this, please feel free to [check them out](http://www.craigkerstiens.com/2012/05/07/why-postgres-part-2/). The cliff notes of them include:

* Window functions
* Functions
* Custom languages (PLV8 anyone?)
* NoSQL datatypes
* Custom functions
* Common table expressions
* Concurrent index creation
* Transactional DDL
* Foreign Data Wrappers
* Conditional and functional indexes
* Listen/Notify
* Table inheritance
* Per transaction synchronous replication
