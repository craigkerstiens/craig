--- 
layout: post
title: "Working with time in Postgres"
tags: Postgres, PostgreSQL
categories: Postgres, PostgreSQL
type: post
published: true
comments: false
syndicate_to_planet: true
---

A massive amount of reporting queries, whether really intensive data analysis, or just basic insights into your business involving looking at data over a certain time period. Postgres has really rich support for dealing with time out of the box, something that's often very underweighted when dealing with a database. Sure, if you have a time-series database it's implied, but even then how flexible and friendly is it from a query perspective? With Postgres there's a lot of key items available to you, let's dig in at the things that make your life easier when querying. <!--more-->

### Date math

The most common thing I find myself doing is looking at users that have done something within some specific time window. If I'm executing this all from my app I can easily inject specific dates, but Postgres makes this really easy for you. Within Postgres you have a type called and interval that is some window of time. And fortunately Postgres takes care of the heavy lifting of how might something translate to or from hours/seconds/milliseconds/etc. Here's just a few examples of things you could do with interals:

* '1 day'::interval
* '5 days'::interval
* '1 week'::interval
* '30 days'::interval
* '1 month'::interval

*A note that if you're looking to remove something like a full month, you actually want to use 1 month instead of trying to calculate yourself.*

With a given interval you can easily shift some window of time, such as finding all users that have signed up for your service within the past week:

```sql
SELECT *
FROM users
WHERE created_at >= now() - '1 week'::interval
```

### Date functions

Date math makes it pretty easy for you to go and find some specific set of data that applies, but what do you do when you want a broader report around time? There's a few options here. One is to leverage the built-in Postgres functions that help you worth with dates and times. `date_trunc` is one of the most used ones that will truncate a date down to some interval level. Here you can use the same general values as the above, but simply pass in the type of interval it will be. So if we wanted to find the count of users that signed up per week:

```
SELECT date_trunc('week', created_at), 
       count(*)
FROM users
GROUP BY 1
ORDER BY 1 DESC;
```

This gives us a nice roll-up of how many users signed up each week. What's missing here though is if you have a week that has no users. In that case because no users signed up there is no count of 0, it just simply doesn't exist. If you did want something like this you could generate some range of time and then do a cross join with it against users to see which week they fell into. To do this first you'd generate a series of dates:

```sql
SELECT generate_series('2017-01-01'::date, now()::date, '1 week'::interval) weeks
```

Then we're going to join this against the actual users table and check that the `created_at` falls within the right range.

```
with weeks as (
  select week as week
  from generate_series('2017-01-01'::date, now()::date, '1 week'::interval) weeks
)

SELECT weeks.week,
       count(*)
FROM weeks,
     users
WHERE users.created_at > weeks.week
  AND users.created_at <= weeks.week - '1 week'::interval
```

### Timestamp vs. Timestamptz

What about storing the times themselves? Postgres has two types of timestamps. It has a generic timestamp and one with timezone embedded in it. In most cases you should generally opt for timestamptz. Why not timestamp? What happens if you move a server, or your server somehow swaps its configuration. Or perhaps more practically what about daylight savings time? In general you might think that you can simply just put in the time as you see it, but when different countries around the world observe things like daylight savings time differently it introduces complexities into your application. 

With timestamptz it'll be aware of the extra parts of your timezone and store your dates correctly. Then when you query from one timezone that accounts for daylights savings you're all covered. There's a [number of articles](http://phili.pe/posts/timestamps-and-time-zones-in-postgresql/) that cover a bit more in depth on the logic between timestamp and timestamp with timezone, so if you're curious I encourage you to check them out, but by default you mostly just need to use timestamptz.

### More

There's a number of other functions and capabilities when it comes to dealing with time in Postrges. You can `extract` various parts of a timesetamp or interval such as hour of the day or the month. You can grab the day of the week with `dow`. And one of my favorites which is when we celebrate happy hour at Citus, there's a literal for UTC 00:00:00 00:00:00 which is [`allballs()`](https://www.postgresql.org/message-id/20050124200645.GA6126%40winnie.fuhr.org). If you need to work with dates and times in Postgres I encourage you to check out the [docs](https://www.postgresql.org/docs/current/static/functions-datetime.html) before you try to re-write something of your own, chances are what you need may already be there.