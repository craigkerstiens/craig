--- 
layout: post
title: Why Postgres
tags: 
- Development, Postgres, Database
categories: [Engineering, Development, Postgres, Database]
type: post
published: true
comments: false
---
	
*This post is a list of many of the reasons to use Postgres, much this content as well as how to use these features will later be curated within [PostgresGuide.com](http://www.postgresguide.com). If you need to get started check out [Postgres.app](http://postgresapp.com) for Mac, or get a Cloud instance at [Heroku Postgres](https://postgres.heroku.com/?utm_source=referral&utm_medium=content&utm_campaign=craigkerstiens) for free*

*UPDATE: A [part 2](/2012/05/07/why-postgres-part-2/) has been posted on [Why Use Postgres](/2012/05/07/why-postgres-part-2/)*

Very often recently I find myself explaining why Postgres is so great. In an effort to save myself a bit of time in repeating this, I though it best to consolidate why Postgres is so great and dispel some of the historical arguments against it. 

## Replication

For some time the biggest argument for MySQL over Postgres was the lack of a good replication story for Postgres. With the release of [8.4 Postgres's](http://www.postgresql.org/docs/8.4/static/high-availability.html) story around replication quickly became much better. 

*While replication is indeed very important, are users actually setting up replication each time with MySQL or is it to only have the option later?*

## Window functions

This is a feature those familiar with Oracle greatly missed in Postgres. In fact even SQL Server had some form of them, though it was with T-SQL, which adds a bit more complexity to the feature. This is a feature that once you have you can't live without; the other options that existed before were slower and much more complicated. With the release of [8.4](http://www.postgresql.org/docs/9.1/static/tutorial-window.html) window functions were added to bring Postgres on par with Oracle in this area. For more info on using them check the Postgres docs above or [PostgresGuide.com](http://postgresguide.com/tips/window.html).

## Flexible Datatypes

Creating a custom column is simpler in Postgres than any other database I've used by far. Excluding custom datatypes, even Postgres's out of the box datatypes make Postgres stand out far ahead of other databases. In particular the ability to create a column as an [Array](http://www.postgresql.org/docs/9.1/static/arrays.html) of some datatype. Want to store a game of tic-tac-toe in a database, or an array of 1 user's phone numbers? It simply becomes a single column that can contain multiple phone numbers for a user. 
<!-- more -->

## Functions

Need to do some logic outside of standard SQL? Postgres likely has a function already available to do it for you. What about the time you wanted to take all rows returned by a query and combine them into a function? Give [array_agg a look](http://www.postgresql.org/docs/9.1/static/functions-aggregate.html). Need to split a string and grab a part of it or some other string action, there's a [function for that](http://www.postgresql.org/docs/9.1/static/functions-string.html). 

## Custom Languages

Want to use another language inside your database? Postgres probably supports it:

* [Python in Postgres](http://www.postgresql.org/docs/9.1/static/plpython.html)
* [Ruby in Postgres](https://github.com/knu/postgresql-plruby)
* [R in Postgres](http://www.joeconway.com/plr/)
* [V8 in Postgres](http://code.google.com/p/plv8js/wiki/PLV8)

## Extensions

Need to go beyond standard Postgres? There's a good chance that someone else has, and that there's already an extension for it. Extensions take Postgres further with things such as Geospatial support, JSON data types, Key Value Stores, and connecting to external data sources (Oracle, MySQL, Redis). I could easily have a full post on extensions available alone, fortunately someone else has already created an awesome one - [PostgreSQL Most Useful Extensions](http://blog.railsware.com/2012/04/23/postgresql-most-useful-extensions/).

## NoSQL gives flexibility

I don't want to get too NoSQL versus SQL debate.... no matter which side you fall on you can get both in Postgres. With hstore and [PLV8](http://code.google.com/p/plv8js/wiki/PLV8) you'll get the flexibility in your data that you would with Mongo along with all of the above features. [Will Leinweber](http://www.twitter.com/leinweber) has a talk that he's given at several conferences recently that highlights [Schemaless SQL](http://ssql-railsconf.herokuapp.com/).

## Custom Functions

Didn't find the function you wanted in the above? Try creating it yourself:

```bash
    CREATE FUNCTION awesomeness(varchar) RETURNS boolean
	    AS 'CASE WHEN $1 == \'postgres\' THEN TRUE ELSE FALSE END;'
	    LANGUAGE SQL
	    IMMUTABLE
	    RETURNS NULL ON NULL INPUT;
```

## Common Table Expressions

Often times when exploring data or creating a new view you'll want to load data into a temporary table. When exploring data you only need this for a temporary time. Why actually go through the effort of putting it into a temporary table, especially if you only need it for a single query. [Common Table Expressions](http://www.postgresql.org/docs/8.4/static/queries-with.html) let you accomplish just that. 

## Development Pace

For some period of time MySQL and Postgres were both moving at fast paces. In recent years though Postgres has rapidly picked up its pace of how much gets packed into a single release. Just take a look at the  [Major Releases](http://en.wikipedia.org/wiki/PostgreSQL#Major_releases). 

## Conclusion

Hopefully you're convinced on why Postgres is a great tool. Next take a visit to [PostgresGuide](http://www.postgresguide.com) if you need some direction on where to start or how to use many of the above features.

<!-- Perfect Audience - why postgres - DO NOT MODIFY -->
<img src="http://ads.perfectaudience.com/seg?add=691030&t=2" width="1" height="1" border="0" />
<!-- End of Audience Pixel -->
