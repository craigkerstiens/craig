--- 
layout: post
title: Arrays in Postgres
tags: 
- Development, Postgres, Array
categories: [Development, Postgres, Array]
type: post
published: true
comments: false
---

Postgres out of the box has an abundance of datatypes, from standard [numeric datatypes](http://www.postgresql.org/docs/9.1/static/datatype.html#DATATYPE-NUMERIC) to [geometric](http://www.postgresql.org/docs/9.1/static/datatype-geometric.html) or even [network datatypes](http://www.postgresql.org/docs/9.1/static/datatype-net-types.html). With extensions you can get even more out of it as earlier discussed with [hStore](http://craigkerstiens.com/2012/06/11/schemaless-django/). Though with all of the datatypes its easy to miss out on some of them that are there, in fact one of my favorites is often missed entirely. The [Array](http://www.postgresql.org/docs/9.1/static/arrays.html) datatype lets you do just as you'd expect, store an array inside Postgres. With this you can often get some of the functionality you'd want in a single table when you might traditionally have expanded to multiple tables. 

The broader question may be why you'd actually want to use an array. One good reason may be if you're an application developer its how you think of your data, so why not model it the same way. As you'll see below it can be easier than joining and aggregating across a set of rows. Also depending on your case you performance could be improved, though mileage may vary here as it does depend on the data you're storing.

First a bit of a hacky example... Lets say you have a basic website that sells stuff, and instead of having a purchase ID and a total you want to include the quantity, id, and price of each item in a single row. With a bit of a messy foreign key (using a decimal) you could store all of this within a single row:

    CREATE TABLE purchases (
	    id integer NOT NULL,
	    user_id integer,
	    items decimal(10,2) [100][1],
		occurred_at timestamp
	);

With this table I could have an array that holds multiple records of:

* The item purchased
* The quantity
* The price

<!-- more -->

An insert to this table would look something like:

    INSERT INTO purchases VALUES (1, 37, '\{\{15.0, 1.0, 25.0\}, \{15.0, 1.0, 25.0\}\}', now());
	INSERT INTO purchases VALUES (2, 2, '{{11.0, 1.0, 4.99}}', now());
	
You can see a full example with UDF's to compute total [here](https://github.com/craigkerstiens/postgres-demo)

A more practical example may actually be using an array for tags. If you were to tag your purchases:
    
	CREATE TABLE products (
	    id integer NOT NULL,
	    title character varying(255),
	    description text,
        tags text[],
	    price numeric(10,2)
	);

You could then query those just as you'd expect with a basic select statement, or could even expand the array to have an individual result per row:

     SELECT title, unnest(tags) items
     FROM products

Protip: If you're using arrays you can also use Postgres' [Gin and Gist](http://www.postgresql.org/docs/9.1/static/textsearch-indexes.html) indexes to search for products quickly that contain certain tags. Given an index you could search where its tagged with some id:

    -- Search where product contains tag ids 1 AND 2
    SELECT  *
	FROM    products
	WHERE   tags @> ARRAY[1, 2]
	
	-- Search where product contains tag ids 1 OR 2
	SELECT  *
	FROM    products
	WHERE   tags && ARRAY[1, 2]

<!-- Perfect Audience - why postgres - DO NOT MODIFY -->
<img src="http://ads.perfectaudience.com/seg?add=691030&t=2" width="1" height="1" border="0" />
<!-- End of Audience Pixel -->
