--- 
layout: post
title: How I work with Postgres – psql, My PostgreSQL Admin 
tags: 
- Database, Postgres
categories: [Database, Postgres]
type: post
published: true
comments: false
---

On at least a weekly basis and not uncommonly multiple times in a single week I get this question:

{% blockquote @neilmiddleton https://twitter.com/neilmiddleton  %}
I've been hunting for a nice PG interface that works within other things. PGAdmin kinda works, except the SQL editor is a piece of shit
{% endblockquote %}

Sometimes it leans more to, what is the Sequel Pro equivilant for Postgres. My default answer is I just use psql, though I do have to then go on to explain how I use it. For those just interested you can read more below or just get the highlights here:

* Set your default `EDITOR` then use \e
* On postgres 9.2 and up `\x auto` is your friend
* Set history to unlimited
* `\d` all the things

Before going into detail on why psql works perfectly fine as an interface I want to rant for a minute about what the problems with current editors are and where I expect them to go in the future. First this is not a knock on the work thats been done on previous ones, for their time PgAdmin, phpPgAdmin, and others were valuable tools, but we're coming to a point where theres a broader set of users of databases than ever before and empowering them is becoming ever more important.

Empowering developers, DBA's, product people, marketers and others to be comfortable with their database will lead to more people taking advantage of whats in their data. [pg_stat_statements](http://craigkerstiens.com/2013/01/10/more-on-postgres-performance/) was a great start to this laying a great foundation for valuable information being captured. Even with all of the powerful stats being captured in the statistics of PostgreSQL so many are still terrified when they see something like:

                                                       QUERY PLAN
    ----------------------------------------------------------------------------------------------------------------
     Hash Join  (cost=4.25..8.62 rows=100 width=107) (actual time=0.126..0.230 rows=100 loops=1)
       Hash Cond: (purchases.user_id = users.id)
       ->  Seq Scan on purchases  (cost=0.00..3.00 rows=100 width=84) (actual time=0.012..0.035 rows=100 loops=1)
       ->  Hash  (cost=3.00..3.00 rows=100 width=27) (actual time=0.097..0.097 rows=100 loops=1)
             Buckets: 1024  Batches: 1  Memory Usage: 6kB
             ->  Seq Scan on users  (cost=0.00..3.00 rows=100 width=27) (actual time=0.007..0.042 rows=100 loops=1)
     Total runtime: 0.799 ms
    (7 rows)

Empowering more developers by surfacing this information in a digestable form, such as building on top of `pg_stat_statements` tools such as [datascope](http://datascope.heroku.com) by [@leinweber](http://www.twitter.com/leinweber) and getting this to be part of the default admin we will truly begin empowering a new set of user.

But enough of a detour, those tools aren't available today. If you're interested in helping build those to make the community better please reach out. For now I live in a work where I'm quite content with simple ole `psql` here's how:

<!--more-->

### Editor

Ensuring you've exported your preferred editor to the environment variable `EDITOR` when you run \e it will allow you to view and edit your last run query in your editor of choice. This works for vim, emacs, or even sublime text. 

    export EDITOR=subl
    psql
    \e 

Gives me:

![sublime text](http://f.cl.ly/items/2I0f3M0B1T3k0d290v3k/Screenshot_2_12_13_9_58_AM.png)

*Note you need to make sure you connect with psql and have your editor set, once you do that saving and exiting the file will then execute the query*

### \x auto

psql has long had a method of formatting output. You can toggle this on and off easily by just running the `\x` command. Running a basic query you get the output:

    SELECT * 
    FROM users 
    LIMIt 1;
     id | first_name | last_name |           email            |    data    |     created_at      |     updated_at      |     last_login
     ----+------------+-----------+----------------------------+------------+---------------------+---------------------+---------------------
       1 | Rosemary   | Wassink   | Rosemary.Wassink@yahoo.com | "sex"=>"F" | 2010-07-01 18:16:00 | 2011-05-14 11:47:00 | 2011-06-07 23:04:00

With toggling the output and re-running the same query we can see how its now formatted:

    \x
    Expanded display is on.
    craig=# SELECT * from users limit 1;
    -[ RECORD 1 ]--------------------------
    id         | 1
    first_name | Rosemary
    last_name  | Wassink
    email      | Rosemary.Wassink@yahoo.com
    data       | "sex"=>"F"
    created_at | 2010-07-01 18:16:00
    updated_at | 2011-05-14 11:47:00
    last_login | 2011-06-07 23:04:00

Using `\x auto` will automatically put this in what Postgres believes is the most intelligible format to read it in. 

### psql history

Hopefully this needs no justification... having an unlimited history of all your queries is incredibly handy. Ensuring you set the following environment variables will ensure you never lose that query you ran several months ago again:

    export HISTFILESIZE=
    export HISTSIZE=

### \d

And while the last on the list one of the first things I do when connecting to any database is check out whats in it. I don't do this by running a bunch of queries but rather checking out the schema and then poking at definitions of specific tables. `\d` and variations on it are incredibly handy for this. Here's a few highlights below:

Listing all relations with simply `\d`:

    \d
                     List of relations
     Schema |       Name       |     Type      | Owner
    --------+------------------+---------------+-------
     public | products         | table         | craig
     public | products_id_seq  | sequence      | craig
     public | purchases        | table         | craig
     public | purchases_id_seq | sequence      | craig
     public | redis_db0        | foreign table | craig
     public | users            | table         | craig
     public | users_id_seq     | sequence      | craig
    (7 rows)

List only all tables with `dt`:

    \dt
             List of relations
     Schema |   Name    | Type  | Owner
    --------+-----------+-------+-------
     public | products  | table | craig
     public | purchases | table | craig
     public | users     | table | craig
    (3 rows)

Describe a specific relation with `\d RELATIONNAMEHERE`:

    \d users
                                         Table "public.users"
       Column   |            Type             |                     Modifiers
    ------------+-----------------------------+----------------------------------------------------
     id         | integer                     | not null default nextval('users_id_seq'::regclass)
     first_name | character varying(50)       |
     last_name  | character varying(50)       |
     email      | character varying(255)      |
     data       | hstore                      |
     created_at | timestamp without time zone |
     updated_at | timestamp without time zone |
     last_login | timestamp without time zone |

One more pro-tip if you're running a transaction with many tables and forget which are involved in it you can run '\d \*transaction\*' and it'll display tables curently affected.

*Have a tool you prefer, have something you use daily in psql that I missed, or interested in helping create a new admin experience please reach out and lets talk craig.kerstiens at gmail.com*

<!-- Perfect Audience - why postgres - DO NOT MODIFY -->
<img src="http://ads.perfectaudience.com/seg?add=691030&t=2" width="1" height="1" border="0" />
<!-- End of Audience Pixel -->
