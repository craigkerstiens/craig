--- 
layout: post
title: Why PostgreSQL Part 2
tags: 
- Development, Postgres, Database
categories: [Engineering, Development, Postgres, Database]
type: post
published: true
comments: false
---

*This post is a list of many of the reasons to use Postgres, much this content as well as how to use these features will later be curated within [PostgresGuide.com](http://www.postgresguide.com). If you need to get started check out [Postgres.app](http://postgresapp.com) for Mac, or get a Cloud instance at [Heroku Postgres](https://postgres.heroku.com/?utm_source=referral&utm_medium=content&utm_campaign=craigkerstiens) for free*

Last week I did a post on the [many reasons to use Postgres](/2012/04/30/why-postgres/). My goal with the post was two fold:

 * Call out some of the historical arguments against it that don't hold any more
 * Highlight some of the awesome but more unique features that are less commonly found in databases.

Once I published the post it was clear and was immediately pointed out in the comments and on [hacker news](http://news.ycombinator.com/item?id=3910743) that I missed quite a few features that I'd mostly come to take for granted. *Perhaps this is due to so much awesomeness existing within Postgres.* A large thanks to everyone for calling these out. To help consolidate many of these, here's a second list of the many reasons to use PostgreSQL:

## Create Index Concurrently

On most traditional databases when you create an index it holds a lock on the table while it creates the index. This means that the table is more or less useless during that time. When you're starting out this isn't a problem, but as your data grows and you then add indexes later to improve performance it could mean downtime just to add an index. Not surprisingly Postgres has a great means of adding an index without holding that lock. Simply doing [`CREATE INDEX CONCURRENTLY`](http://www.postgresql.org/docs/9.1/static/sql-createindex.html#SQL-CREATEINDEX-CONCURRENTLY) instead of `CREATE INDEX` will create your index without holding the lock.

*Of course with many features there are caveats, in the case of creating your index concurrently it does take somewhere on the order of 2-3 times longer, and cannot be done within a transaction*

## Transactional DDL

If you've ever run a migration had something break mid-way, either due to a constraint or some other means you understand what pain can come of quickly untangling such. Typically migrations on a schema are intended to be run holistically and if they fail you want to fully rollback. Some other databases such as Oracle in recent versions and SQL server do support, this. And of course Postgres supports wrapping your DDL inside a transaction. This means if an error does occur you can simply rollback and have the previous DDL statements rolled back with it, leaving your schema migrations as safe as your data, and your application in a consistent state.

## Foreign Data Wrappers

I talked before about other languages within your database such as Ruby or Python, but what if you wanted to talk to other databases from your database. Postgres's Foreign Data Wrapper allows you to fully wrap external data systems and join on them in a similar fashion to as if they existed locally within the database. Here's a sampling of just a few of the foreign data wrappers that exist:

 * [Oracle](http://pgxn.org/dist/oracle_fdw/)
 * [MySQL](http://pgxn.org/dist/mysql_fdw/)
 * [Redis](http://pgxn.org/dist/redis_fdw/)
 * [Twitter](http://pgxn.org/dist/twitter_fdw/)

In fact you can even use [Multicorn](http://multicorn.org/) to allow you to write other foreign data wrappers in Python. An example of how this can be done, in this case with Database.com/Force.com can be found [here](http://blog.database.com/blog/2011/11/21/a-database-comforce-com-foreign-data-wrapper-for-postgresql/) 
<!-- more -->

## Conditional Constraints and Partial Indexes

In a similar fashion to affecting only part of your data you may care about an index on only a portion of your data. Or you may care about placing a constraint only where a certain condition is true. Take an example case of the white pages. Within the white pages you only have one active address, but you've had multiple ones over recent years. You likely wouldn't care about the past addresses being indexed, but would want everyones current address to be indexed. With [Partial Indexes](http://www.postgresql.org/docs/9.1/static/indexes-partial.html) becomes simple and straight forward:

```bash 
    CREATE INDEX idx_address_current ON address (user_id) WHERE current IS True;
```

## Postgres in the Cloud

Postgres has been chosen by individual shops and been proven to scale by places such as [Instagram](http://media.postgresql.org/sfpug/instagram_sfpug.pdf) and [Disqus](http://ontwik.com/python/disqus-scaling-the-world%E2%80%99s-largest-django-application/). Perhaps even more importantly it's becoming easy to use PostgreSQL due to the many clouds that are running Postgres as a Service, such as: 

 * [Heroku Postgres](http://postgres.heroku.com) 
 * [VMware vFabric](http://www.vmware.com/products/application-platform/vfabric-data-director/features.html)
 * [Enterprise DB](http://www.enterprisedb.com/)
 * [Cloud Postgres](https://www.cloudpostgres.com)

*Full disclosure, I work at [Heroku](http://www.heroku.com), and am also a large fan of their database service*

## Listen/Notify

If you want to use your database as a queue there's some cases where it just won't work, as heavily discussed in a [recent write-up](http://mikehadlow.blogspot.se/2012/04/database-as-queue-anti-pattern.html). However, much of this could be discarded if you included Postgres in this discussion due to Listen/Notify. Postgres will allow you to [LISTEN](http://www.postgresql.org/docs/9.1/static/sql-listen.html) to an event and of course [NOTIFY](http://www.postgresql.org/docs/9.1/static/sql-notify.html) for when the event has occurred. A great example of this in action is [Ryan Smith's](http://www.twitter.com/ryandotsmith) [Queue Classic](https://github.com/ryandotsmith/queue_classic).

## Fast column addition/removal

Want to add a column or remove one. With millions of records this modification in some databases could take seconds or even minutes, in cases I've even heard horror stories of adding a column taking hours. With Postgres this is a near immediate action. The only time you pay a higher price is when you choose to write default data to a new column.

## Table Inheritance

Want inheritance in your database just like you have in with models inside your application code? Not a problem for Postgres. You can have one table easily inherit for another, leaving a cleaner data model within your database while still giving all the flexibility you'd like on your data model. The Postgres docs on [DDL Inheritance](http://www.postgresql.org/docs/9.1/static/ddl-inherit.html) do a great job of documenting how to use this and giving a very simple but clear use case.

## Per transaction synchronous replication

The default mode for Postgres streaming replication is asynchronous. This works well when you want to maintain performance, but also care about your data. There are cases where you want your replication to be [synchronous](http://www.postgresql.org/docs/current/static/warm-standby.html#SYNCHRONOUS-REPLICATION) though. Furthermore, for some cases asynchronous may work well enough where as other data you may care more about the data and want synchronous replication, within the same database. For example, if you care about user sign-ups and purchases, but ratings of products and comments is less important Postgres provides the ability to treat them as such. With Postgres you can have per transaction synchronous replication, this means you could have strong data guarantee on your user and purchase transactions, and less guarantees on others. This means you only pay the extra performance cost where you really care about versus an all or nothing approach you have with other databases.

## Conclusion

Hopefully you're convinced on why Postgres is a great tool, if not take a look back at my [previous post](/2012/04/30/why-postgres/). 

<!-- Perfect Audience - why postgres - DO NOT MODIFY -->
<img src="http://ads.perfectaudience.com/seg?add=691030&t=2" width="1" height="1" border="0" />
<!-- End of Audience Pixel -->
