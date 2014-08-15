--- 
layout: post
title: My wishlist for Postgres 9.5
tags: Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

As I followed along with the [9.4 release](/2014/03/24/Postgres-9.4-Looking-up/) of Postgres I had a few posts of things that I was excited about, some things that missed, and a bit of a wrap-up. I thought this year (year in the sense of PG releases) I'd jump the gun and lay out areas I'd love to see addressed in PostgreSQL 9.5. And here it goes:

<!--more-->

### Upsert

Merge/Upsert/Insert or Update whatever you want to call it this is still a huge wart that it doesn't exist. There's been a few implementations show up on mailing lists, and to the best of my understanding there's been debate on if it's performant enough or that some people would prefer another implementation or I don't know what other excuse. The short is this really needs to happen, until that time you can always [implement it with a CTE](http://stackoverflow.com/questions/1109061/insert-on-duplicate-update-in-postgresql/8702291#8702291) which can have a race condition.

### Foreign Data Wrappers

There's so much opportunity here, and this has easily been my [favorite feature of the past 2-3 years in Postgres](/2013/08/05/a-look-at-FDWs/). Really any improvement is good here, but a hit list of a few valuable things:

* Pushdown of conditions
* Ability to accept a DSN to a utility function to create foreign user and tables.
* Better security around creds of foreign tables
* More out of the box FDWs

### Stats/Analytics

Today there's [madlib](http://madlib.net/) for machine learning, and 9.4 got support for [ordered set aggregates](http://www.depesz.com/2014/01/11/waiting-for-9-4-support-ordered-set-within-group-aggregates/), but even still Postgres needs to keep moving forward here. PL-R and PL-Python can help a good bit as well, but having more out of the [box functions](http://www.postgresql.org/docs/9.3/static/functions-aggregate.html) for stats can continue to keep it at the front of the pack for a database that's not only safe for your data, but powerful to do analysis with.

### Multi-master

This is definitely more of a dream than not. Full multi-master replication would be amazing, and it's getting closer to possible. The sad truth is even once it lands it will probably require a year of maturing, so even more reason for it to hopefully hit in 9.5

### Logical Replication

The foundation made it in for 9.4 which is huge. This means we'll probably see a good working out of the box logical replication in 9.5. For those less familiar this means the replication is SQL based vs. the binary WAL stream. This means things like using replication to upgrade across versions is possible. So not quite 0 downtime, but ~ a minute or two to upgrade versions. Even of large DBs.

### An official GUI

Alright this one is probably a pipe dream. And to kick it off, no pgAdmin doesn't cut it. A good end user tool for connecting/querying would be huge. Fortunately the ecosystem is improving here with [JackDB](http://www.jackdb.com) (web based) and [PG Commander](https://eggerapps.at/pgcommander/) (mac app), but these still aren't discoverable enough for most users.

### What do you want?

So there's my wishlist, what's yours for 9.5? Let me know - [@craigkerstiens](http://www.twitter.com/craigkerstiens).