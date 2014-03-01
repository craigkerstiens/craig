--- 
layout: post
title: PostgreSQL 9.4 - What I was hoping for
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

Theres no doubt that the [9.4 release](/2014/02/02/Examining-PostgreSQL-9.4/) of PostgreSQL will have some great improvements. However, for all of the improvements it delivering it had the promise of being perhaps the most impactful release of [Postgres](http://www.amazon.com/dp/B008IGIKY6?tag=mypred-20) yet. Several of the features that would have given it my stamp of best release in at least 5 years are now already not making it and a few others are still on the border. Here's a look at few of the things that were hoped for and not to be at least until another 18 months.

<!--more-->

### Upsert

Upsert, merge, whatever you want to call it, this is been a sore hole for sometime now. Essentially this is insert based on this ID or if that key already exists update other values. This was something being worked on pretty early on in this release, and throughout the process continuing to make progress. Yet as progress was made so were exteneded discussions about syntax, approach, etc. In the end two differing views on how it should be implemented have the patch still sitting there with other thoughts on an implementation but not code ready to commit.

At the same time I'll acknowledge upsert as a hard problem to address. The locking and concurrency issues are non-trivial, but regardless of those having this in there mostly kills the final argument for anyone to chose MySQL.

### Better JSON

JSON is Postgres is super flexible, powerful, and **generally slow**. Postgres does validation and some parsing of JSON, but without something like [PLV8](https://postgres.heroku.com/blog/past/2013/6/5/javascript_in_your_postgres/), or [functional indexes](http://www.craigkerstiens.com/2013/05/29/postgres-indexes-expression-or-functional-indexes/) you may not get great performance. This is because under the covers the JSON is represented as text and as a result many of the more powerful indexes that could lend benefit, such as GIN or GIST, simply don't apply here. 

As a related effort to this [hstore](http://postgresguide.com/sexy/hstore.html), the key/value store, is working on being updated. This new support will add types and nesting making it much more usable overall. However the syntax and matching of how JSON functions isn't guranteed to be part of it. The proposal and actually work is still there and not rejected yet, but looks heavily at risk. Backing a new binary representation of JSON with hstore 2 would deliver so many benefits further building upon the foundation of hstore, JSON, PLV8 that exists today for Postgres.

### apt-get for your extensions

I'm almost not even sure where to start with this one. The notion within a Postgres community is that packaging for distros is super simple and extensions should just be packaged for them. Then there's [PGXN](http://pgxn.org/) the Postgres extension network where you can download and compile and muck with annoying settings to get extensions to build. This proposal would have delivered a built in installer much like NPM or rubygems or PyPi and the ability for someone to simply say install extension from this centralized repository. No, it was setting out to solve the issue of having a single repository but would make it much easier for people to run one. 

For all the awesome-ness that exists in extensions such as [HyperLogLog](http://tapoueh.org/blog/2013/02/25-postgresql-hyperloglog), [foreign data wrappers](http://www.craigkerstiens.com/2012/10/18/connecting_to_redis_from_postgres/), [madlib](http://madlib.net/) theres hundreds of other extensions that could be written and be valuable. They don't even all require C, they could fully exist in JavaScript with PLV8. Yet I'm on the fence encouraging people to write such because if no one uses it then much of the point in the reusability of an extension is lost. Here's hoping that there's a change of opinion in the future that packaging is a solved problem and that creating an ecosystem for others to contribute to the Postgres world without knowing C is a positive thing.

### Logical replication

When I first heard this might have some shot at making it in 9.4 I was shocked. This is something that while some may not take notice of I've felt pain of for many years. Logical replication means in short enabling upgrades across PostgreSQL versions without a dump and restore, but even more so laying the ground work for more complicated architectures like perhaps multi-master. Yes, even with logical replication in theres still plenty of work to do, but having the groundwork laid goes a long way. There are options for it today with third party tools, but the management of these is painful at best. 

### In conclusion 

The positive of this one is that the building blocks are in and its continuing to make progress. Its just that we'll have to wait about 18 months before the release of PostgreSQL 9.5 before its in our hands. 