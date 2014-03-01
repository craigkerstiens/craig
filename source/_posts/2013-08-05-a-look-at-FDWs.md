--- 
layout: post
title: A look at Foreign Data Wrappers
tags: 
- Postgres, SQL, PostgreSQL
categories: [Postgres, SQL, PostgreSQL]
type: post
published: true
comments: false
---

There are two particular sets of features that continue to keep me very excited about the momentum of Postgres. And while PostgreSQL has had some great momentum in the past few years these features may give it an entirely new pace all together. One is extensions, which is really its own category. Dimitri Fontaine was talking about doing a full series just on extensions, so here's hoping he does so I dont have to :) 

One subset of extensions which I consider entirely separate is the other thing, which is foreign data wrappers or FDWs. FDWs allow you to connect to other data sources from within Postgres. From there you can query them with SQL, join across disparate data sets, or join across different systems. Recently I had a good excuse to give the `postgres_fdw` a try. And while I've blogged about the Redis FDW previously, the Postgres one is particularly exciting because with PostgreSQL 9.3 it will ship as a contrib module, which means all Postgres installers should have it... you just have to turn it on.

<!--more-->

Let's take a look at getting it setup and then dig into it a bit. First, because I don't have Postgres 9.3 sitting around on my system I'm going to provision one from Heroku Postgres:

    $ heroku addons:add heroku-postgresql:crane --version 9.3

Once it becomes available I'm going to connect to it then enable the extension:

    $ heroku pg:psql BLACK -acraig
    # CREATE EXTENSION postgres_fdw;

Now its there, so we can actually start using it. To use the FDW there's four basic things you'll want to do:

1. Create the remote server
2. Create a user mapping for the remote server
3. Create your foreign tables
4. Start querying some things

### The setup

You'll only need to do each of the following once, once you're server, user and foreign table are all setup you can simply query away. This is a nice advantage over db_link which only exists for the set session. *One downside I did find was that you can't use a full Postgres connection string, which would make setting it up much simpler*. So onto setting up our server:

    # CREATE SERVER app_db 
      FOREIGN DATA WRAPPER postgres_fdw 
      OPTIONS (dbname 'dbnamehere', host 'hostname-here);

Next we'll actually create our user mapping. In this case we'll take the remote username and password and map it to our current user we're already connected with. 

    # CREATE USER MAPPING for user_current 
      SERVER app_db 
      OPTIONS (user 'remote_user', password 'remote_password');

And finally we're going to configure our tables. *There were some additional pains here as there wasn't a perfectly clean way to generate the `CREATE TABLE`. Sure you could pg_dump just that table, but overall it felt a bit cludgey.*

    # CREATE FOREIGN TABLE users
      (
      	id integer,
      	email text,
    	  created_at timestamp,
    	  first_name text,
    	  last_name text
      )
      SERVER app_db OPTIONS (table_name 'users')

Now we've got all of our local data, as well as remote data. For that report against two databases where you previously wrote a ruby or python script, ran a query, constructed another query, then executed it you can directly do in your database. We can simply query our new table - `SELECT * FROM users LIMIT 5;`

But the real power of foreign data wrappers goes well beyond just Postgres to Postgres. Having a defined contract in translating from one system to another, will really allow reinventing the way we work with data. This is especially true in large datasets where doing ETL on terrabytes of data takes longer than asking the questions of it.

While we're waiting for more FDWs to be ready to use in production situations the Postgres FDW is a great start, *though the Redis one is on its way*. Even better is that it ships with standard installs of Postgres, meaning it will see more usage and help push them to advance further. 

*One final nicety, you're not required to have ALL Postgres 9.3 DBs, just one that can then connect to the others, so go ahead and give it try :)*