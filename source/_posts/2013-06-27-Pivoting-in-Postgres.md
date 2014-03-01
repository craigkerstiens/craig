--- 
layout: post
title: Pivoting in Postgres
tags: 
- Postgres, SQL, PostgreSQL
categories: [Postgres, SQL, PostgreSQL]
type: post
published: true
comments: false
---

Earlier today on an internal Heroku group alias there was a [dataclip](https://postgres.heroku.com/dataclips) shared. The dataclip listed off some data grouped by a category, there was a reply a few minutes later with a modification to the query that used the `crosstab` function to pivot directly in SQL. There were immediately several reactions on the list that went something like this:

![mindblown](http://f.cl.ly/items/1b0G101r0B2W243b2933/Image%202013.06.27%202%3A06%3A23%20PM.gif)

While a mostly simple function in Postgres (there are a few rough edges), it really is all too handy. So here it is in action. Taking some data that looks like

* row identifier, in this case date
* category grouping, in this case OS
* value

<!--more-->

Given a really basic query that generates some sample data it may look something like this:

    SELECT generate_series AS date,
           b.desc AS TYPE,
           (random() * 10000 + 1)::int AS val
    FROM generate_series((now() - '100 days'::interval)::date, now()::date, '1 day'::interval),
      (SELECT unnest(ARRAY['OSX', 'Windows', 'Linux']) AS DESC) b;

  You get results that look like:

<iframe _tmplitem="2"  src='https://dataclips.heroku.com/cwtnbdhfkpgjhegzktolakjkkpyj/embed?result=1&version=1' width="500px" height="300px"></iframe>

But of course this isn't overly helpful in comparing day to day overall. You can do so on a OS by OS basis, but its annoying enough as is. The easy solution is to simply use a pivot table on your data. Most people at this point would pull it up into Excel or Google Docs, or you can do it directly in Postgres. To do so you'll first enable the extension `tablefunc`:

    CREATE EXTENSION tablefunc

Then you'll use the crosstab function. The function looks something like:

    SELECT * 
    FROM crosstab(
      'SELECT row_name, category_grouping, value FROM foo',
      'SELECT category_names FROM bar')
    AS
      ct_result (category_name text, category1 text, category2 text, etc.)

Lets see it an actual action. Given the same query we used to generate fake data we can actually pivot on it now directly in PostgreSQL:

    SELECT *
    FROM crosstab(
      'SELECT
        a date,
        b.desc AS os,
        (random() * 10000 + 1)::int AS value
         FROM generate_series((now() - ''100 days''::interval)::date, now()::date, ''1 DAY''::interval) a,
              (SELECT unnest(ARRAY[''OSX'', ''Windows'', ''Linux'']) AS DESC) b ORDER BY 1,2
      ','SELECT unnest(ARRAY[''OSX'', ''Windows'', ''Linux''])'
    ) 
    AS ct(date date, OSX int, Windows int, Linux int);

And see some results:

<iframe _tmplitem="1"  src='https://dataclips.heroku.com/dgzcrjoqqjzsxzditlrzpblljgbn/embed?result=1&version=2' width="500px" height="300px"></iframe>

Have fun analyzing your data directly in your DB now. And as always if you have feedback/questions/requests please feel free to drop me a line [craig.kerstiens@gmail.com](mailto:craig.kerstiens@gmail.com)