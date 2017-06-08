--- 
layout: post
title: My top 10 Postgres features and tips for 2016
tags: Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

I find during the holiday season many pick up [new books](http://www.amazon.com/Hard-Thing-About-Things-Building/dp/0062273205/ref=sr_1_1?ie=UTF8&qid=1451407536&sr=8-1&keywords=hard+thing+about&tag=mypred-20), learn a [new language](http://crystal-lang.org/), or brush up on some other skill in general. Here's my contribution to hopefully giving you a few new things to learn about Postgres and ideally utilize in the new year. It's not in a top 10 list as much as 10 tips and tricks you should be aware of as when you need them they become incredibly handy. But, first a shameless plug if you find any of the following helpful, consider subscribing to [Postgres weekly](http://www.postgresweekly.com) a weekly newsletter with interesting Postgres content.

<!--more-->

### 1. CTEs - Common Table Expressions

CTEs allow you to do crazy awesome things like recursive queries but even the most simple form of them I don't go a day without using. Think of a CTE or commonly known as with clause as a view inside the time that query is running. This lets you more easily create readable query. Any query that's constructed that's even [100 lines long](/2013/11/18/best-postgres-feature-youre-not-using/), but with 4-5 CTEs is undoubtedly going to be easier for someone new to come in and understand than a 20 line query that does the same thing. A few people like writing SQL, but no one likes reading someone else's so do them a favor and read up on CTEs.

### 2. Setup a .psqlrc

You setup a bashrc, vimrc, etc. Why not do the same for Postgres. Some of the great things you can do:

* Setup pretty formatting by default with `\x auto`
* Set nulls to actually look like something `\pset null ¤`
* Turn timing on by default `\timing on`
* Customize your prompt `\set PROMPT1 '%[%033[33;1m%]%x%[%033[0m%]%[%033[1m%]%/%[%033[0m%]%R%# '`
* Save commonly run queries that you can run by name

Here's an example of my own `psqlrc`:

    \set QUIET 1
    \pset null '¤'

    -- Customize prompts
    \set PROMPT1 '%[%033[1m%][%/] # '
    \set PROMPT2 '... # '

    -- Show how long each query takes to execute
    \timing

    -- Use best available output format
    \x auto
    \set VERBOSITY verbose
    \set HISTFILE ~/.psql_history- :DBNAME
    \set HISTCONTROL ignoredups
    \set COMP_KEYWORD_CASE upper
    \unset QUIET

### 3. pg_stat_statements for where to index

`pg_stat_statements` is probably the single most valuable tool for improving performance on your database. Once enabled (with `create extension pg_stat_statements`) it automatically records all queries run against your database and records often and how long they took. This allows you to then go and find areas you can optimize to get overall time back with one simple query:

    SELECT 
      (total_time / 1000 / 60) as total_minutes, 
      (total_time/calls) as average_time, 
      query 
    FROM pg_stat_statements 
    ORDER BY 1 DESC 
    LIMIT 100;
    
*Yes, there is some performance cost to leaving this always on, but it's pretty small. I've found it's far more useful to be on and get major performance wins vs. the small cost of it always recording.*

You can read much more on Postgres performance on a [previous post](http://www.craigkerstiens.com/2013/01/10/more-on-postgres-performance/)

### 4. Slow down with ETL, use FDWs

If you have a lot of *microservices* or different apps then you likely have a lot of different databases backing them. The default for about anything you want to do is do create some data warehouse and ETL it all together. This often goes a bit too far to the extreme of aggregating **everything** together. 

For the times you just need to pull something together once or on rare occasion [foreign data wrappers](http://www.craigkerstiens.com/2013/08/05/a-look-at-FDWs/) will let you query from one Postgres database to another, or potentially from Postgres to anything else such as [Mongo](https://github.com/citusdata/mongo_fdw) or Redis.

### 5. array and array_agg

There's little chance if you're building an app you're not using arrays somewhere within it. There's no reason you shouldn't be doing the same within your database as well. Arrays can be just another datatype within Postgres and have some great use cases like tags for blog posts directly in a single column.

But, even if you're not using arrays as a datatype there's often a time when you want to rollup something like an array in a query then comma separate it. Something similar to the following could allow you to easily roll up a comma separated list of projects per user:

    SELECT 
      users.email,
      array_to_string(array_agg(projects.name), ',')) as projects
    FROM
      projects,
      tasks,
      users
    WHERE projects.id = tasks.project_id
      AND tasks.due_at > tasks.completed_at
      AND tasks.due_at > now()
      AND users.id = projects.user_id
    GROUP BY 
      users.email

### 6. Use materialized views cautiously

If you're not familiar with materialized view they're a query that has been actually created as a table. So it's a materialized or basically snapshotted version of some query or "view". In their initial version materialized versions, which were long requested in Postgres, were entirely unusuable because when you it was a locking transaction which could hold up other reads and acticities avainst that view. 

They've since gotten much better, but there's no tooling for refreshing them out of the box. This means you have to setup some scheduler job or cron job to regularly refresh your materialized views. If you're building some reporting or BI app you may undoubtedly need them, but their usability could still be advanced so that Postgres knew how to more automatically refresh them. 

*If you're on Postgres 9.3, the above caveats about preventing reads still does exist*

### 7. Window functions 

Window functions are perhaps still one of the more complex things of SQL to understand. In short they let you order the results of a query, then compute something from one row to the next, something generally hard to do without procedural SQL. You can do some very basic things with them such as rank where [each result appears](http://postgresguide.com/sql/window.html) ordered by some value, or something more complex like compute [MoM growth directly in SQL](http://www.craigkerstiens.com/2014/02/26/Tracking-MoM-growth-in-SQL/).

### 8. A simpler method for pivot tables

Table_func is often referenced as the way to compute a pivot table in Postgres. Sadly though it's pretty difficult to use, and the more basic method would be to just do it with raw SQL. This will get much better with [Postgres 9.5](http://www.craigkerstiens.com/2015/12/27/postgres-9-5-feature-rundown/), but until then something where you sum up each condition where it's true or false and then totals is much simpler to reason about:

    select date,
           sum(case when type = 'OSX' then val end) as osx,
           sum(case when type = 'Windows' then val end) as windows,
           sum(case when type = 'Linux' then val end) as linux
    from daily_visits_per_os
    group by date
    order by date
    limit 4;

*Example query courtesy of [Dimitri Fontaine](http://www.twitter.com/tapoueh) and [his blog](http://tapoueh.org/blog/2013/07/04-Simple-case-for-pivoting).*

### 9. PostGIS

Sadly on this one I'm far from an expert. PostGIS is arguably the best option of any GIS database options. The fact that you get all of the standard Postgres benefits with it makes it even more powerful–a great example of this is GiST indexes which came to Postgres in recent years and offers great performance gains for PostGIS. 

If you're doing something with geospatial data and need something more than the easy to use `earth_distance` extension then crack open PostGIS. 

### 10. JSONB

I almost debated leaving this one off the list, ever since Postgres 9.2 JSON has been at least one of the marquees in each Postgres release. JSON arrived with much hype, and JSONB fulfilled on the initial hype of Postgres starting to truly compete as a document database. JSONB only continues to become more powerful with [better libraries](http://www.craigkerstiens.com/2015/12/08/massive-json/) for taking advantage of it, and it's [functions improving](https://wiki.postgresql.org/wiki/What's_new_in_PostgreSQL_9.5#JSONB-modifying_operators_and_functions) with each release. 

If you're doing anything with JSON or playing with another document database and ignoring JSONB you're missing out, of course don't forget the GIN and GiST indexes to really get the benefits of it. 

### The year ahead

Postgres 9.5/9.6 should continue to improve and bring many new features in the years ahead, what's your preference for something that doesn't exist yet but you do want to see land in Postgres. Let me know [@craigkerstiens](http://www.twitter.com/craigkerstiens)