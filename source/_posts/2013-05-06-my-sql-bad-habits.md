--- 
layout: post
title: My SQL Bad Habits
tags: 
- Postgres, SQL
categories: [Postgres, SQL]
type: post
published: true
comments: false
---

I'm reasonably proficient at SQL – *a coworker when pseudocoding some logic for him pointed out that my pseudocode is what he thought was executable SQL*. I'm fully capable of writing clear and readable SQL – which most SQL is not. Despite that I still have several bad habits when it comes to SQL. Without further adieu heres some of my dirty laundry so hopefully others can not make the same mistakes.

<!--more-->

### Order/Group by Column Numbers

When quickly iterating on a query its a lot less typing to put the column number as the thing you want to order by. Here's a quick lightweight example:

    SELECT
      email,
      created_at
    FROM 
      users
    ORDER BY 2 DESC
    LIMIT 5;



This gives me my last 5 users that have signed up for my site. Of course as soon as I have this I may want to add some data to it, like their first name so I can send them a welcome email. I quickly alter the query to:

    SELECT
      email,
      first_name,
      created_at
    FROM 
      users
    ORDER BY 2 DESC
    LIMIT 5;

And now I have 5 users that have signed up ordered by their first name. Sure its obvious when you have 1 column you're ordering by, but when you have `GROUP BY 1, 2, 3, 4, 5, 6` which is actually open in one of my tabs currently its a bit more confusing....

*Though if you really want to have some fun, share a query with someone that looks something like this:*

    SELECT
      email as "3",
      first_name "2",
      created_at "1"
    FROM 
      users
    ORDER BY "1", "3" DESC
    LIMIT 5;
    

### Implicit Joins

I seldom use the syntax `INNER JOIN`. Instead I simply put the two tables in my where clause and ensure I have a where condition. The problem with ensuring I have a where condition is sometimes I don't, especially when you're dealing with 3 tables.

    SELECT 
      email,
      product.name,
      product.price
    FROM 
      users,
      orders,
      items
    WHERE users.id = orders.user_id
      AND orders.id = items.order_id

Is less clear (especially when dealing with 5-6 tables) than the alternative:

    SELECT 
      email,
      product.name,
      product.price
    FROM users
    INNER JOIN orders on users.id = orders.user_id
    INNER JOIN items on orders.id = items.order_id

### Lack of comments

I comment my SQL far less than I comment my code, yet it can be done just as easily. For example I have this in one of my queries:

    SELECT convert_from(CAST(E'\\x' || array_to_string(ARRAY(
       SELECT 
         CASE 
           WHEN length(r.m[1]) = 1 
         THEN encode(convert_to(r.m[1], 'SQL_ASCII'), 'hex') 
         ELSE substring(r.m[1] from 2 for 2) 
         END
      FROM regexp_matches(url_here, '%[0-9a-f][0-9a-f]|.', 'gi') AS r(m)
    ), '') AS bytea), 'UTF8');

While this has its own issues theres no documentation around what this actually does, in contrast:

    --- DECODES url ---
    SELECT convert_from(CAST(E'\\x' || array_to_string(ARRAY(
       SELECT 
         CASE 
           WHEN length(r.m[1]) = 1 
         THEN encode(convert_to(r.m[1], 'SQL_ASCII'), 'hex') 
         ELSE substring(r.m[1] from 2 for 2) 
         END
      FROM regexp_matches(url_here, '%[0-9a-f][0-9a-f]|.', 'gi') AS r(m)
    ), '') AS bytea), 'UTF8');

Comments also work well inline at the end of a line.

### Large Manually Generated Lists

A lot of times in working with some specific data set I'll manually or automatically generate a list that I want to filter. A common example is filtering out staging/dev environments. I'll often manually search and prune the list, then save that result for the queries I'm going to build going forward. This is a bit of effort but still feels reasonable the downside is it results in something like:

    SELECT 
      foo
    FROM 
      bar
    WHERE 
      bar.id NOT IN (34723, 42735, 32321, 47205, 20375, 30261, 26194, 109371, 9313, 6351, 20184, 50273, 34735, 39854, 23954, 25323, 23405, 30528, 50182, 29340, 47659, ... and the list goes on)

SQL is meant to be reasonable for containing some level of logic. Data changes, hard coding keys is going to bite you at some point, spend the extra effort and re-use something thats clear.

### What else

I'm sure theres plenty more; I suspect within a few minutes of sitting down with someone they could point out some other bad habits. While I know mine at least some of mine I still often know the trade-off. What are yours? I'd love to hear to document them for others so hopefully they can prevent developing the same bad habits. Let me know; <a href="mailto:craig.kerstiens@gmail.com">craig.kerstiens@gmail.com</a>

<!-- ### In, Subqueries and Lots of Data

Its really easy to build up a huge list of users then filter something else based on that list of users for if they're not in it. Its also really shitty on performance in most cases. A good example might be if I have 100,000 users on my site but want to find which ones have never made a purchase. Part of this results in knowing your data, but if only 10k have never made a purchase this can give you pretty bad results by doing: The quick and dirty way to do this might be:

    SELECT 
      count(*)
    FROM 
      users
    WHERE 
      user_id NOT IN 
      (
        SELECT user_id
        FROM orders
      )

-->