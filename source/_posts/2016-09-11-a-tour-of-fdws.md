--- 
layout: post
title: A tour of Postgres' Foreign Data Wrappers
tags: Postgres
categories: [Postgres]
type: post
published: true
comments: false
syndicate_to_planet: true
---

SQL can be a powerful language for reporting. Whether you're just exploring some data, or generating reports that show [month over month revenue growth](/2014/02/26/Tracking-MoM-growth-in-SQL/) it's the [lingua franca](https://www.amazon.com/SQL-Relational-Theory-Write-Accurate/dp/1491941170/ref=sr_1_1?s=books&ie=UTF8&qid=1473612603&sr=1-1&keywords=sql+relational&tag=mypred-20) for data analysis. But, your data isn't always in a SQL database, even then if you're using Postgres you can still likely use SQL to analyze, query, even joing with that data. Foreign data wrappers have been around for years in Postgres, but are continuing to mature and be a great option for joining disparate systems.

### Overview of foreign data wrappers

If you're unfamiliar, foreign data wrappers, or FDW, allow you to connect from within Postgres to a remote system. Then you can query them from directly within Postgres. While there is an official Postgres FDW that ships with Postgres itself, that allows you to connect from one Postgres DB to another, there's also a broad community of others. 

At the core of it Postgres provides certain APIs under the covers which each FDW extension can implement. This can include the ability to map SQL to whatever makes sense for a given system, push down various operators like where clauses, and as of Postgres 9.3 can even write data. <!--more-->

To setup a FDW you first would install the extension, then provide the connection to the remote system, setup your schema/tables, and then you're off to the races–or well ready to query. If you've got more than 2-3 databases or systems in your infrastructure, you'll often benefit from FDWs as opposed to introducing a heavyweight ETL pipeline. Don't mistake FDWs as the most performant method for joining data, but they are often the developer time efficient means of joining these data sets.

Let's look at just a few of the more popular and interesting ones.

### Postgres FDW

The Postgres one is the easiest to get started with. First you'll just enable it with `CREATE EXTENSION`, then you'll setup your remote server:

    CREATE EXTENSION postgres_fdw;

    CREATE SERVER core_db 
     FOREIGN DATA WRAPPER postgres_fdw 
     OPTIONS (host 'foo', dbname 'core_db', port '5432');

Then you'll create the user that has access to that database:

    CREATE USER MAPPING FOR bi SERVER core OPTIONS (user 'bi', password 'secret');

Finally, create your foreign table:

    CREATE FOREIGN TABLE core_users (
      id          integer NOT NULL,
      username    varchar(255),
      password    varchar(255),
      last_login  timestamptz
    )
    SERVER core;

Now you'll see a new table in the database you created this in called `core_users`. You can query this table just like you'd expect: 

    SELECT *
    FROM core_users
    WHERE last_login >= now() - '1 day'::interval;

You can also join against local tables, such as getting all the invoices for users that have logged in within the last month:

    SELECT *
    FROM invoices, core_users
    WHERE core_users.last_login >= now() - '1 month::interval'
      AND invoices.user_id = core_users.id

Hopefully this is all straight forward enough, but let's also take a quick look at some of the other interesting ones:

### MySQL FDW

For MySQL you'll also have to [download it](https://github.com/EnterpriseDB/mysql_fdw) and install it as well since it doesn't ship directly with Postgres. This should be fairly straight forward:

    $ export PATH=/usr/local/pgsql/bin/:$PATH
    $ export PATH=/usr/local/mysql/bin/:$PATH
    $ make USE_PGXS=1
    $ make USE_PGXS=1 install

Now that you've built it you'd follow a very similar path to setting it up as we did for Postgres:

    CREATE EXTENSION mysql_fdw;
    
    CREATE SERVER mysql_server
     FOREIGN DATA WRAPPER mysql_fdw
     OPTIONS (host '127.0.0.1', port '3306');
    
    CREATE USER MAPPING FOR postgres
     SERVER mysql_server
     OPTIONS (username 'foo', password 'bar');
    
    CREATE FOREIGN TABLE core_users (
      id          integer NOT NULL,
      username    varchar(255),
      password    varchar(255),
      last_login  timestamptz
     )
     SERVER mysql_server;

But MySQL while different than Postgres is also more similar in SQL support than say a more exotic NoSQL store. How well do they work as a foreign data wrapper? Let's look at our next one:

### MongoDB

First you'll go through much of the [same setup](https://github.com/EnterpriseDB/mongo_fdw) as you did for MySQL. The one major difference though is in the final step to setup the `table`. Since a table doesn't quite map in the same way with Mongo you have the ability to set two items: 1. the database and 2. the collection name. 

    CREATE FOREIGN TABLE core_users(
         _id NAME,
         user_id int,
         user_username text,
         user_last_login timestamptz)
    SERVER mongo_server
         OPTIONS (database 'db', collection 'users');

With this you can do some basic level of filtering as well:

    SELECT * 
    FROM core_users
    WHERE user_last_login >= now() - '1 day'::interval;

You can also write and delete data as well now just using SQL:

    DELETE FROM core_users 
    WHERE user_id = 100;

Of course just putting SQL on top of Mongo doesn't mean you get all the flexibility of analysis that you'd have directly within Postgres, this does go a long way towards allowing you to analyze data that lives across two different systems.

### Many more

A few years ago there were some key ones which already made FDWs useful. Now there's a rich list covering probably every system you could want. Whether it's [Redis](http://www.craigkerstiens.com/2012/10/18/connecting_to_redis_from_postgres/), a simple [CSV](https://www.postgresql.org/docs/9.5/static/file-fdw.html) one, or something newer like [MonetDB](https://github.com/snaga/monetdb_fdw) chances are you can find an [FDW](https://wiki.postgresql.org/wiki/Foreign_data_wrappers#NoSQL_Database_Wrappers) for the system you need that makes your life easier. 