--- 
layout: post
title: 
tags: Hands on Postgres Sharding
categories: [Postgres]
type: post
published: true
comments: false
syndicate_to_planet: yes
---

***Notice**: Much of this post still applies, but now applies more directly to [Citus](https://www.citusdata.com). Since this post originally published, pg_shard is now deprecated. Citus now has an open source version which offer a superset of the features of pg_shard, as well as a [cloud](https://www.citusdata.com/products/cloud) offering. Finally you can find some further guidance for sharding on the [Citus blog](https://www.citusdata.com/blog/) and [docs](http://docs.citusdata.com)*

Back in 2012 I wrote an overview of database sharding. Since then I've had a few questions about it, which have really increased in frequency over the last two months. As a result I thought I'd do a deeper dive with some actual hands on for sharding. Though for this hands on, because I do value my time I'm going to take advantage of `pg_shard` rather than creating mechanisms from scratch. 

For those unfamiliar [pg_shard](https://github.com/citusdata/pg_shard/) is an open source extension from [Citus data](http://citusdata.com) who has a commerical product that you can think of is pg_shard++ (and probably much more). Pg_shard adds a little extra to let data automatically distribute to other Postgres tables (logical shards) and Postgres databases/instances (physical shards) thus letting you outgrow a single Postgres node pretty simply. 

Alright, enough talk about it, let's get things up and running. 

<!--more-->

### Build, install

*The rest assume you have Postgres.app, version 9.5 setup and are on a Mac, much of these steps could be easily adapted for other Postgres installs or OSes.*

PATH=/Applications/Postgres.app/Contents/Versions/latest/bin/:$PATH make

sudo PATH=/Applications/Postgres.app/Contents/Versions/latest/bin/:$PATH make install

cp /Applications/Postgres.app/Contents/Versions/9.5/share/postgresql/postgresql.conf.sample /Applications/Postgres.app/Contents/Versions/9.5/share/postgresql/postgresql.conf.sample

Edit your `postgresql.conf`:

    #shared_preload_libraries = ''

TO:

    shared_preload_libraries = 'pg_shard'

Then create a file in `/Users/craig/Library/Application\ Support/Postgres/var-9.5/pg_worker_list.conf` where `craig` is your username:

    # hostname port-number
    localhost  5432
    localhost  5433

You'll also need to create a new Postgres instance: 

    initdb -D /Users/craig/Library/Application\ Support/Postgres/var-9.5-2
    
Then edit that `postgresql.conf` inside that newly created folder with two main edits:

    port = 5432

To 

    port = 5433

Finally setup our database then start it up:

    createdb instagram
    postgres -D /Users/craig/Library/Application\ Support/Postgres/var-9.5-2

### Setup

Now you should have two running instances of Postgres, now let's finally turn on the pg_shard extension, create some tables and see what we have. First connect to your main running Postgres instance, so in this case the the instagram database we first created `psql instagram`, then let's set things up:

    CREATE EXTENSION pg_shard;
    CREATE TABLE customer_reviews (customer_id TEXT NOT NULL, review_date DATE, review_rating INTEGER, product_id CHAR(10));

     CREATE TABLE
     Time: 4.734 ms

    SELECT master_create_distributed_table(table_name := 'customer_reviews',                                                                                                     partition_column := 'customer_id');

     master_create_distributed_table
     ---------------------------------

     (1 row)

    SELECT master_create_worker_shards(table_name := 'customer_reviews',                                                                                                     shard_count := 16,                                                                                                                                        replication_factor := 2);

     master_create_worker_shards
     -----------------------------
     
     (1 row)

### Understanding and using

So that was a lot of initial setup. But now we have an application that could in theory scale to a shared application across 16 instances. If you want a refresher, there's a difference between physical and logical shards. In this case above we have 16 logical ones and it's replicated across 2 physical Postgres instances albeit on the same instance. 

Alright so a little more poking under the covers to see what happened before we actually start doing something with our data. If you're still connected go ahead and run `\d`, and you should see:

                    List of relations
     Schema |          Name          | Type  | Owner
    --------+------------------------+-------+-------
     public | customer_reviews       | table | craig
     public | customer_reviews_10000 | table | craig
     public | customer_reviews_10001 | table | craig
     public | customer_reviews_10002 | table | craig
     public | customer_reviews_10003 | table | craig
     public | customer_reviews_10004 | table | craig
     public | customer_reviews_10005 | table | craig
     public | customer_reviews_10006 | table | craig
     public | customer_reviews_10007 | table | craig
     public | customer_reviews_10008 | table | craig
     public | customer_reviews_10009 | table | craig
     public | customer_reviews_10010 | table | craig
     public | customer_reviews_10011 | table | craig
     public | customer_reviews_10012 | table | craig
     public | customer_reviews_10013 | table | craig
     public | customer_reviews_10014 | table | craig
     public | customer_reviews_10015 | table | craig
    (17 rows)

You can see that under the cover there's a lot more `customer_reviews` tables, in reality you don't have to think about these or do anything with them. But just for reference they're just plain ole Postgres tables under the cover. You can query them and poke at the data. The now mystical `customer_reviews` will actually roll up the data across all your logical shards (tables) and physical shards (spanning across machines). 

*It's also of note that in production you might not actually use your primary DB as a worker, we did this more for expediency in setting it up on a local Mac. More typically you'd have 2 or more workers which are not the same a the primary, these were the ports we setup in our `pg_worker_list.conf`.*    A common setup would look something more like:

![](https://s3.amazonaws.com/f.cl.ly/items/3T2N2Q1K041g0a0L0j03/Untitled.png?v=7df00f6b)

So now start inserting away: 

    INSERT INTO customer_reviews (customer_id, review_rating) VALUES ('HN802', 5);
    INSERT INTO customer_reviews (customer_id, review_rating) VALUES ('FA2K1', 10);

For extra homework on your own you can now go and poke at where the underlying data actually surfaced. 

### Conclusion 

Yes, there's a number of limitations that you can learn a bit more about over on the [github repo for pg_shard](https://github.com/citusdata/pg_shard#limitations). Though even with those it's very usable as is, and let's you get quite far in prepping an app for sharding. While I will say that all apps think they'll need sharding and few actually do, given `pg_shard` it's minimal extra effort now to plan for such scaling should you need it. 

Up next we'll look at how it'd work with a few languages, so you can get an idea of the end to end experience.