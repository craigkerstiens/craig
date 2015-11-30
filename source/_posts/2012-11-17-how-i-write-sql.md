--- 
layout: post
title: How I Write SQL
tags: 
- Development
categories: [Development]
type: post
published: true
comments: false
---

I recently got asked by [a friend](http://rzrsharp.net/) and former co-worker how I write SQL. At first this caught me by surprise and I assumed there was nothing different, but after a few additional comments on it, it became clear most people have no concept for creating clean readable SQL. So without further adieu here's how I write SQL, with a built up example query. 

<!--more-->

First let's understand an example schema:

    # \dt
     Schema |            Name            | Type  |     Owner      
	--------+----------------------------+-------+----------------
	 public | app_rating                 | table |     craig
	 public | app_recommendation         | table |     craig
	 public | app_userprofile            | table |     craig
	 public | app_wine                   | table |     craig
	 public | app_winemakeup             | table |     craig
	 public | app_winery                 | table |     craig
	 public | auth_user                  | table |     craig

The above schema contains wines from wineries, that users give ratings and notes to. Especially relevant is the app_rating table, it contains a variety of things we're going to want report against:

    # \d app_rating
	                                    Table "public.app_rating"
	   Column   |           Type           |                        Modifiers                        
	------------+--------------------------+---------------------------------------------------------
	 id         | integer                  | not null default nextval('app_rating_id_seq'::regclass)
	 user_id    | integer                  | not null
	 wine_id    | integer                  | not null
	 rated_at   | date                     | not null
	 rating     | integer                  | not null
	 notes      | text                     | 
	 tags       | character varying(255)[] | 
	 created_at | timestamp with time zone | not null
	
Most of the above should be pretty straightforward, though if you're unfamiliar with Arrays in Postgres check out [this earlier article](/2012/08/20/arrays-in-postgres/)

Given all this data lets say we want to produce some query that for a given wine contains  the winery, the average rating, the tags for it. Diving in I'll typically start by creating each key part then pulling it together. Let's start with grabbing the average. 

But first some basic structure, for maximum readability I make sure to use all caps for reserved SQL words. For a large query I make sure all my columns/conditions are on their own line. So to get the average it would look something like this:

    SELECT 
      avg(rating),
      wine_id
    FROM 
      app_wine
    GROUP BY
      wine_id;

Next I'll work with the array of tags which has some specific things to Postgres:

    SELECT DISTINCT
      unnest(tags) as tag,
      wine_id
    FROM 
      app_rating
    GROUP BY 
      wine_id, tags;

Finally I'm going to put it all together. This is going to have an additional query to get the winery and the wine name as well. We're also going to use CTE's (Common Table Expressions), think of these as temporary views that can make your query more readable:

    WITH 

      wine_ratings as (
        SELECT 
          avg(rating) as rating,
          wine_id
        FROM 
          app_rating
        GROUP BY
          wine_id),

      wine_tags as (
	    SELECT DISTINCT
          unnest(tags) as tag,
          wine_id
        FROM 
          app_rating
        GROUP BY 
          wine_id, tags),

      wine_detail as (
	    SELECT
          app_wine.name as name,
          app_wine.id,
          app_winery.name as winery
        FROM
          app_wine,
          app_winery
        WHERE app_wine.winery_id = app_winery.id
       )  
   

    SELECT 
      name,
      rating,
      array_agg(tag),
      winery
    FROM
      wine_ratings,
      wine_detail
    LEFT OUTER JOIN 
      wine_tags ON wine_detail.id = wine_tags.wine_id
    WHERE wine_detail.id = wine_ratings.wine_id
    GROUP BY 
      name,
      rating,
      winery
    ORDER BY
      rating DESC

One thing to point out, is `SELECT`, `FROM` and `ORDER BY` are followed by a new line. When I have `WHERE` multiple conditions I ensure the `AND` and the condition occur on the same line. This is intentional to make those easier to read as well as easy to remove/add. The key to allowing it to still be readable is an extra two spaces before the `AND` so the condition aligns with the above one. This would appear something similar to:

    SELECT foo
    FROM bar
    WHERE foo.id = bar.foo_id
      AND foo.created_at > now() - '7 days'::INTERVAL

And just for an example we get this result from the query:

             name          | rating |   array_agg        |         winery         
	-----------------------+--------+--------------------+------------------------
	 Bordeaux Blend        |   5.0  | {'dry', 'smooth'}  | Chateau Rahoul
	 Cabernet Franc        |   5.0  | {'chocolate'}      | Beaucanon
	 Cabernet Sauvignon    |   5.0  | {'young', 'dry'}   | Hawkes

While very long, this should ideally be quite legible. 

<!-- Perfect Audience - why postgres - DO NOT MODIFY -->
<img src="http://ads.perfectaudience.com/seg?add=691030&t=2" width="1" height="1" border="0" />
<!-- End of Audience Pixel -->

