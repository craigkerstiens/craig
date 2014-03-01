--- 
layout: post
title: Postgres Indexes – Expression/Functional Indexing
tags: 
- Postgres, SQL
categories: [Postgres, SQL]
type: post
published: true
comments: false
---

Postgres is rich with options for indexing. First you've got a variety of types, and beyond that you can do a variety of things with each of these such as create unique indexes, use conditions to index only a portion of your data, or create indexes based on complex expressions or functions. In cases where you commonly use various PostgreSQL functions in your application or reporting you can get some great gains from this.

<!--more-->

Let's take a look at a really simple case. Given a basic user table:

    # \dt users
                     Table "public.users"
       Column   |            Type             | Modifiers
    ------------+-----------------------------+-----------
     id         | integer                     | not null
     email      | character varying(255)      |
     created_at | timestamp without time zone |

You may commonly want to run a report against it showing your signups by date. Let's say you do this by running the query:

    SELECT 
      count(*),
      date_trunc('day', created_at)
    FROM 
      users
    GROUP BY 
      2;

If you're commonly using `date_trunc('day', created_at)` for grouping, filtering, or projecting it out you can get some great gains by creating an index on this:

    # CREATE INDEX idx_user_created ON users(date_trunc('day', created_at));

Of course you can go beyond the built in functions of Postgres and use more complicated functions you create yourself. For example if you have JSON stored within PostgreSQL, have PLV8 enabled, and want to create a Javascript function to parse and return the text for a given key:

    # CREATE OR REPLACE FUNCTION
    get_text(key text, data json)
    RETURNS text $$
      return data[key];
    $$ LANGUAGE plv8 IMMUTABLE STRICT;

*Of note in the above function is `IMMUTABLE` and `STRICT`. Immutable specifies that the function given the same inputs will return the same result. Strict means that if you send in `NULL` values you'll get a null result.* 

Given some example data inside your JSON field:

    {
      "name": "Craig Kerstiens",
      "location": "San Francisco",
      "numbers": [
        {
          "type":   "work",
          "number": "123.456.7890"
        },
        {
          "type":   "home",
          "number": "987.654.3210"
        }
      ]
    }

If you wanted to return just the name you could index on:

    # CREATE INDEX idx_name ON users(get_text('name', json_data));

Or even combine with built ins for a case-insensitive version:

    # CREATE INDEX idx_name ON users(lower(get_text('name', json_data)));

Indexes like all of the above can be useful when you're filtering on something that postgres can take advantage of. In most cases any conditions with the exception of a `LIKE` beginning with a `%` work for this. With Postgres 9.2 even a count(*) in certain cases can take advantage of the index because of index only scans.

Whether you're looking to take advantage of all the power of Javascript with JSON or another procedural langauge – or simply speed up a basic report using built in functions expression indexes can give you some great benefits. 

*Based on early feedback theres already a plan to create an article that includes a bit on composite indexes, cost of indexing, how to know if its not being used. Is there more you want to know more about Postgres Indexes or other topics in PostgreSQL? Drop me a line [mailto:craig.kerstiens@gmail.com](craig.kerstiens at gmail.com) and let me know in more detail.*

<!-- Perfect Audience - why postgres - DO NOT MODIFY -->
<img src="http://ads.perfectaudience.com/seg?add=691030&t=2" width="1" height="1" border="0" />
<!-- End of Audience Pixel -->