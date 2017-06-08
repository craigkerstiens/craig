--- 
layout: post
title: Simple but handy Postgres features
tags: Postgres, PostgreSQL
categories: Postgres, PostgreSQL
type: post
published: true
comments: false
syndicate_to_planet: false
---

It seems each week when I'm reviewing data with someone a feature comes up that they had no idea existed within Postgres. In an effort to continue documenting many of the features and functionality that are useful, here's a list of just a few that you may find handy the next time your working with your data.

### Psql, and \e

This one I've [covered before](http://www.craigkerstiens.com/2013/02/13/How-I-Work-With-Postgres/), but it's worth restating. Psql is a great editor that already comes with Postgres. If you're comfortable on the CLI you should consider giving it a try. You can even setup you're own `.psqlrc` for it so that it's well customized to your liking. In particular turning `\timing` on is especially useful. But even with all sorts of customization if you're not aware that you can use your preferred editor by using `\e` then you're missing out. This will allow you to open up the last run query, edit it, save–and then it'll run for you. Vim, Emacs, even Sublime text works just take your pick by setting your `$EDITOR` variable. 

<!--more-->

### Watch

Ever sit at a terminal running a query over and over to see if something on your system changed? If you're debugging something whether locally or even live in production, watching data change can be key to figuring out. Instead of re-running your query you could simply use the `\watch` command in Postgres, this will re-run your query automatically every few seconds. 

```sql
SELECT now() - 
       query_start, 
       state, 
       query 
FROM pg_stat_activity 
\watch 
```

### JSONB pretty print

I love [JSONB](https://www.citusdata.com/blog/2016/07/14/choosing-nosql-hstore-json-jsonb/) as a datatype. Yes, in cases it won't be the [optimal](http://blog.heapanalytics.com/when-to-avoid-jsonb-in-a-postgresql-schema/) for performance (though at times it can be perfectly fine). If I'm hitting some API that returns a ton of data, I'm usually not using all of it right away. But, you never know when you'll want to use the rest of it. I use [Clearbit](https://www.clearbit.com) this way today, and for safety sake I save all the JSON result instead of de-normalizing it. Unfortunately, when you query this in Postgres you get one giant compressed text of JSON. Yes, you could pipe out to something like jq, or you could simply use Postgres built in function to make it legible:

```sql
SELECT jsonb_pretty(clearbit_response)
FROM lookup_data;

                                jsonb_pretty
-------------------------------------------------------------------------------
 { 
     "person": { 
         "id": "063f6192-935b-4f31-af6b-b24f63287a60", 
         "bio": null, 
         "geo": { 
             "lat": 37.7749295, 
             "lng": -122.4194155,                                              
             "city": "San Francisco", 
             "state": "California", 
             "country": "United States", 
             "stateCode": "CA", 
             "countryCode": "US" 
         }, 
         "name": { 
         ...
```

### Importing my data into Google

This one isn't Postgres specific, but I use it on a weekly basis and it's key for us at [Citus](https://www.citusdata.com). If you use something like Heroku Postgres, dataclips is an extremely handy feature that lets you have a real-time view of a query and the results of it, including an anonymous URL you can it for it. At Citus much like we did at Heroku Postgres we have a dashboard in google sheets which pulls in this data in real-time. To do this simple select a cell then put in: `=importdata("pathtoyourdataclip.csv")`. Google will import any data using this as long as it's in CSV form. It's a great lightweight way to build out a dashboard for your business without rolling your own complicated dashboarding or building out a complex ETL pipeline.

I'm sure I'm missing a ton of the smaller features that you use on a daily basis. Let me know [@craigkerstiens](https://www.twitter.com/craigkerstiens) the ones I forgot that you feel should be listed.
