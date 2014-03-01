--- 
layout: post
title: Examining Postgres 9.4 - A first look
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

[PostgreSQL](http://www.amazon.com/dp/B008IGIKY6?tag=mypred-20) is currently entering its final commit fest. While its still going, which means there could still be more great features to come, we can start to take a look at what you can expect from it now. This release seems to bring a lot of minor increments versus some bigger highlights of previous ones. At the same time there's still a lot on the bubble that may or may not make it which could entirely change the shape of this one. For a peek back of some of the past ones:

<!--more-->

### Highlights of 9.2

* [pg_stat_statements](/2013/01/10/more-on-postgres-performance/)
* [Index only scans](https://wiki.postgresql.org/wiki/Index-only_scans)
* [JSON Support](https://postgres.heroku.com/blog/past/2012/12/6/postgres_92_now_available/#json_support)
* [Range types](https://postgres.heroku.com/blog/past/2012/12/6/postgres_92_now_available/#range_type_support)
* Huge performance improvements

### Highlights of 9.3

* [Postgres foreign data wrapper](/2013/08/05/a-look-at-FDWs/)
* [Materialized views](https://postgres.heroku.com/blog/past/2013/9/9/postgres_93_now_available/#materialized_views)
* Checksums

## On to 9.4

With 9.4 instead of a simply list lets dive into a little deeper to the more noticable one. 

### pg_prewarm

I'll lead with one that those who need it should see huge gains (read larger apps that have a read replica they eventually may fail over to). Pg_prewarm will pre-warm your cache by loading data into memory. You may be interested in running `pg_prewarm` before bringing up a new Postgres DB or on a replica to keep it fresh.

*Why it matters*  - If you have a read replica it won't have the same cache as the leader. This can work great as you can send queries to it and it'll optimize its own cache. However, if you're using it as a failover when you do have to failover you'll be running in a degraded mode while your cache warms up. Running `pg_pregwarm` against it on a periodic basis will make the experience when you do failover a much better one.

### Refresh materialized view concurrently

Materialized views just came into Postgres in 9.3. The problem with them is they were largely unusable. This was because they 1. Didn't auto-refresh and 2. When you did refresh them it would lock the table while it ran the refresh making it unreadable during that time. 

Materialized views are often most helpful on large reporting tables that can take some time to generate. Often such a query can take 10-30 minutes or even more to run. If you're unable to access said view during that time it greatly dampens their usefulness. Now running `REFRESH MATERIALIZED VIEW CONCURRENTLY foo` will regenerate it in the background so long as you have a unique index for the view.

### Ordered Set Aggregates

I'm almost not really sure where to begin with this, the name itself almost makes me not want to take advantage. That said what this enables is if a few really awesome things you could do before that would require a few extra steps. 

While there's plenty of aggregate functions in postgres getting something like percentile 95 or percentile 99 takes a little more effort. First you must order the entire set, then re-iterate over it to find the position you want. This is something I've commonly done by using a window function coupled with a CTE. Now its much easier:

    SELECT percentile_disc(0.95) 
    WITHIN GROUP (ORDER BY response_time) 
    FROM pageviews;

In addition to varying percentile functions you can get quite a few others including:

* Mode
* percentile_disc
* percentile_cont
* rank
* dense_rank

### More to come

As I mentiend earlier the commit fest is still ongoing this means some things are still in flight. Here's a few that still offer some huge promise but haven't been committed yet:

* Insert on duplicate key or better known as Upsert
* HStore 2 - various improvements to HStore
* JSONB - Binary format of JSON built on top of HStore
* Logical replication - this one looks like some pieces will make it, but not a wholey usable implementation.