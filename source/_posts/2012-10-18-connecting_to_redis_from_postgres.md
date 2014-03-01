--- 
layout: post
title: Redis in my Postgres
tags: 
- Development, Postgres, Database, Redis
categories: [Development, Postgres, Database, Redis]
type: post
published: true
comments: false
---

Yesterday there was a post which hit [Hacker News](http://news.ycombinator.com/item?id=4664178) that talked about using [SQL to access Mongo](http://www.citusdata.com/blog/51-run-sql-on-mongodb). While this is powerful I think much of the true value was entirely missed within the post.

SQL is an expressive language, though people are often okay with accessing Mongo data through its own ORM. The real value is that you could actually query the data from within Postgres then join across your data stores, without having to do some ETL process to move data around.  Think... joining sales data from Postgres with user reviews stored in Mongo or searching for visits to a website (retained in redis) against purchases by user in Postgres.

The mechanism pointed out was a MongoDB Foreign Data Wrapper. A Foreign Data Wrapper or FDW essentially lets you connect to an external datastore from within a Postgres database. In addition to the Mongo FDW released the other day there's  many others. For example Postgres 9.0 and up ships with one called `db_link`, which lets you query and join across two different Postgres databases. Beyond that there's support for a variety of other data stores including some you may have never expected:

* [Redis](http://pgxn.org/dist/redis_fdw/)
* [Textfile](http://pgxn.org/dist/file_textarray_fdw/)
* [MySQL](http://pgxn.org/dist/mysql_fdw/)
* [Oracle](http://pgxn.org/dist/oracle_fdw/)
* [ODBC](http://pgxn.org/dist/odbc_fdw/)
* [LDAP](http://pgxn.org/dist/ldap_fdw/)
* [Twitter](http://pgxn.org/dist/twitter_fdw/)
* [More](http://pgxn.org/tag/fdw/)


Lets look at actually getting the Redis one running then see what some of the power of it really looks like. First we have to get the code then build it:

<!--more-->

    git clone git://github.com/antirez/hiredis.git
    cd hiredis
    make 
    sudo make install

Then download the FDW from [PGXN](http://pgxn.org/dist/redis_fdw/)

    PATH=/Applications/Postgres.app/Contents/MacOS/bin/:$PATH USE_PGXS=1 make
    sudo PATH=/Applications/Postgres.app/Contents/MacOS/bin/:$PATH USE_PGXS=1 make install

Now you'll want to connect to your Postgres database, using `psql` and enable the extension, and finally create your foreign table to your redis server. This is assuming a locally running redis, though you could connect to a remote just as easily:
    
    CREATE EXTENSION redis_fdw;

    CREATE SERVER redis_server 
		FOREIGN DATA WRAPPER redis_fdw 
		OPTIONS (address '127.0.0.1', port '6379');

	CREATE FOREIGN TABLE redis_db0 (key text, value text) 
		SERVER redis_server
		OPTIONS (database '0');

	CREATE USER MAPPING FOR PUBLIC
		SERVER redis_server
		OPTIONS (password 'secret');
		
With `dt` we can now see the list of all of our tables:

    # \dt
	         List of relations
	 Schema |   Name    | Type  | Owner 
	--------+-----------+-------+-------
	 public | products  | table | craig
	 public | purchases | table | craig
	 public | users     | table | craig
	(3 rows)
	
And with a full `\d` we can see not just the tables but also see we have a foreign table as well:

    # \d
	                 List of relations
	 Schema |       Name       |     Type      | Owner 
	--------+------------------+---------------+-------
	 public | products         | table         | craig
	 public | purchases        | table         | craig
	 public | redis_db0        | foreign table | craig
	 public | users            | table         | craig
	(4 rows)

Finally we can actually query against it:

    # SELECT * from redis_db0 limit 5;   
       key   | value 
    ---------+-------
     user_40 | 44
     user_41 | 32
     user_42 | 11
     user_43 | 3
     user_80 | 7
    (5 rows)

Or more interestingly we can join it against other parts of our data and filter accordingly. Below we'll show users that have logged in at least 40 times:

    SELECT 
	  id, 
	  email, 
	  value as visits 
	FROM 
	  users, 
	  redis_db0 
	WHERE 
	      ('user_' || cast(id as text)) = cast(redis_db0.key as text) 
	  AND cast(value as int) > 40;

	 id |           email            | visits 
	----+----------------------------+--------
	 40 | Cherryl.Crissman@gmail.com | 44
	 44 | Brady.Paramo@gmail.com     | 44
	 46 | Laronda.Razor@yahoo.com    | 44
	 47 | Karole.Sosnowski@gmail.com | 44
	 12 | Jami.Jeon@yahoo.com        | 49
	 14 | Jenee.Morrissey@gmail.com  | 47
	 16 | Yuki.Alber@yahoo.com       | 48
	 18 | Marquis.Tartaglia@aol.com  | 44
	 31 | Collin.Parrilla@gmail.com  | 46
	 39 | Nydia.Bukowski@aol.com     | 47
	  2 | Gaye.Monteith@aol.com      | 48
	  6 | Letitia.Tripodi@aol.com    | 41
	(12 rows)
	
While several of the current FDWs are not production ready yet, some are more battle tested including db_link, textfile, ODBC and MySQL ones.
