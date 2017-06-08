--- 
layout: post
title: Getting started with JSONB in Postgres
tags: Postgres, PostgreSQL
categories: Postgres, PostgreSQL
type: post
published: true
comments: false
syndicate_to_planet: true
---

JSONB is an awesome datatype in Postgres. I find myself using it on a weekly basis these days. Often in using some API (such as [clearbit](https://www.clearbit.com)) I'll get a JSON response back, instead of parsing that out into a table structure it's really easy to throw it into a JSONB then query for various parts of it. 

*If you're not familiar with JSONB, it's a binary representation of JSON in your database. You can read a bit more about it vs. JSON [here](https://www.citusdata.com/blog/2016/07/14/choosing-nosql-hstore-json-jsonb/).*

In working with JSONB here's a few quick tips to get up and running with it even faster: <!--more-->

### Indexing

For the most part you don't have to think to much about this. With Postgres powerful indexing types you can add one index and have everything within the JSON document, all the keys and all the values, automatically indexed. The key here is to add a `GIN` index. Once this is done queries should be much faster where you're searching for some value:

```sql
CREATE INDEX idx_data ON companies USING GIN (data);
```

### Querying

Querying is a little bit more work, but once you get the basics it can be pretty straight forward. There's a few new operators you'll want to quickly ramp up on and from there querying becomes easy.

For the most basic part you now have an operator so traverse down the various keys. First let's get some idea of what the JSON looks like so we can have something to work with. Here's a sample set of data that we get back from Clearbit:

```
{
  "domain": "citusdata.com",
  "company": {
    "id": "b1ff2bdf-0d8d-4d6d-8bcc-313f6d45996a",
    "url": "http:\/\/citusdata.com",
    "logo": "https:\/\/logo.clearbit.com\/citusdata.com",
    "name": "Citus Data",
    "site": {
      "h1": null,
      "url": "http:\/\/citusdata.com",
      "title": "Citus Data",
    },
    "tags": [
      "SAAS",
      "Enterprise",
      "B2B",
      "Information Technology & Services",
      "Technology",
      "Software"
    ],
    "domain": "citusdata.com",
    "twitter": {
      "id": "304455171",
      "bio": "Builders of Citus, the extremely scalable PostgreSQL database.",
      "site": "https:\/\/t.co\/hKpZjIy7Ej",
      "avatar": "https:\/\/pbs.twimg.com\/profile_images\/630900468995108865\/GJFCCXrv_normal.png",
      "handle": "citusdata",
      "location": "San Francisco, CA",
      "followers": 3770,
      "following": 570
    },
    "category": {
      "sector": "Information Technology",
      "industry": "Internet Software & Services",
      "subIndustry": "Internet Software & Services",
      "industryGroup": "Software & Services"
    },
    "emailProvider": false
  }
}
```

Sorry it's a bit long, but it gives us a good example to work with. 

### Basic lookups

Now let's query something fairly basic, the domain:

```sql
# SELECT data->'domain' 
FROM companies 
WHERE domain='citusdata.com' 
LIMIT 1;

    ?column?
-----------------
 "citusdata.com"
```

The `->` is likely the first operator you'll use in JSONB. It's helpful to traverse the JSON. Though of you're looking to get the value as text you'll actually want to use `->>`. Instead of giving you some quoted response back or JSON object you're going to get it as text which will be a bit cleaner:

```sql
# SELECT data->>'domain' 
FROM companies 
WHERE domain='citusdata.com' 
LIMIT 1;

    ?column?
-----------------
 citusdata.com
```

### Filtering for values

Now with something like clearbit you may want to filter out for only certain type of companies. We can see in the example data that there's a bunch of tags. If we wanted to find only companies that had the tag B2B we could use the `?` operator once we've targetted down to that part of the JSON. The `?` operator will tell us if some part of JSON has a top level key:

```sql
SELECT *
FROM companies
WHERE data->'company'->'tags' ? 'B2B'
```

### JSONB but pretty

In querying JSONB you'll typically get a nice compressed set of JSON back. While this is all fine if you're putting it into your application, if you're manually debugging and testing things you probably want something a bit more readable. Of course Postgres has your back here and you can wrap your JSONB with a pretty print function:

```sql
SELECT jsonb_pretty(data)
FROM companies;
```

### Much more

There's a lot more in the [docs](https://www.postgresql.org/docs/9.5/static/functions-json.html) that you can find handy for the specialized cases when you need them. `jsonb_each` will expand a JSONB document into individual rows. So if you wanted to count the number of occurences of every tag for a company, this would help. Want to parse out a JSONB to a row/record in Postgres there's `jsonb_to_record`. The docs are your friends for about everything you want to do but hopefully these few steps help kick start things if you want to get started with `JSONB`.
