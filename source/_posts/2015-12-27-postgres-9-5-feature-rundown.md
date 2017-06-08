--- 
layout: post
title: Postgres 9.5 - The feature rundown
tags: Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

The headline of Postgres 9.5 is undoubtedly: Insert... on conflict do nothing/update or more commonly known as Upsert or Merge. This removes one of the last remaining features which other databases had over Postgres. Sure we'll take a look at it, but first let's browse through some of the other features you can look forward to when Postgres 9.5 lands:

<!--more-->

### Grouping sets, cube, rollup

Pivoting in Postgres has [sort of been possible](http://www.craigkerstiens.com/2013/06/27/Pivoting-in-Postgres/) as has rolling up data, but it required you to know what those values and what you were projecting to, to be known. With the new functionality to allow you to group various sets together rollups as you'd normally expect to do in something like Excel become trivial. 

So now instead you simply add the grouping type just as you would on a normal group by:

    SELECT department, role, gender, count(*)
    FROM employees
    GROUP BY your_grouping_type_here;

By simply selecting the type of rollup you want to do Postgres will do the hard work for you. Let's take a look at the given example of department, role, gender:

* `grouping sets` will project out the count for each specific key. As a result you'd get each department key, with other keys as null, and the count for each that met that department. 
* `cube` will give you the same values as above, but also the rollups of every individual combination. So in addition to the total for each department, you'd get breakups by the department and gender, and department and role, and department and role and gender. 
* `rollup` will give you a slightly similar version to cube but only give you the detailed groupings in the order they're presented. So if you specified `roll (department, role, gender)` you'd have no rollup for department and gender alone. 

*Check the what's new wiki for a bit more clarity on [examples and output](https://wiki.postgresql.org/wiki/What's_new_in_PostgreSQL_9.5#GROUPING_SETS.2C_CUBE_and_ROLLUP)*

### Import foreign  schemas 

I only use foreign tables about once a month, but when I do use them they've inevitably saved many hours of creating a one off ETL process. Even still the effort to setup new foreign tables has shown a bit of their infancy in Postgres. Now once you've setup your foreign database, you can import the schema, either all of it or specific tables you prefer. 

It's as simple as:

    IMPORT FOREIGN SCHEMA public
    FROM SERVER some_other_db INTO reference_to_other_db;

### pg_rewind

If you're managing your own Postgres instance for some reason and running HA, pg_rewind could become especially handy. Typically to spin up replication you have to first download the physical, also known as base, backup. Then you have to replay the Write-Ahead-Log or WAL–so it's up to date then you actually flip on replication. 

Typically with databases when you fail over you shoot the other node in the head or [STONITH](https://en.wikipedia.org/wiki/STONITH). This means just get rid of it, completely throw it out. This is still a good practice, so bring it offline, make it inactive, but from there now you could then flip it into a mode and use pg_rewind. This could save you pulling down lots and lots of data to get a replica back up once you have failed over. 

### Upsert

Upsert of course will be the highlight of Postgres 9.5. I already talked about it some when [it initially landed](http://www.craigkerstiens.com/2015/05/08/upsert-lands-in-postgres-9.5/). The short of it is, if you're inserting a record and there's a conflict, you can choose to:

* Do nothing
* Do some form of update

Essentially this will let you have the typically experience of create or update that most frameworks provide but without a potential race condition of incorrect data. 

### JSONB pretty

There's a few updates [to JSONB](https://wiki.postgresql.org/wiki/What's_new_in_PostgreSQL_9.5#JSONB-modifying_operators_and_functions). The one I'm most excited about is making JSONB output in psql read much more legibly. 

If you've got a JSONB field just give it a try with:

    SELECT jsonb_pretty(jsonb_column)
    FROM foo;

### Give it a try

Just in time for the new year [the RC is ready](http://www.postgresql.org/about/news/1631/) and you can get hands on with it. Give it a try, and if there's more you'd like to hear about Postgres please feel free to drop me a note [craig.kerstiens@gmail.com](mailto:craig.kerstiens@gmail.com).

<script type="text/javascript">
  (function() {
    window._pa = window._pa || {};
    // _pa.orderId = "myOrderId"; // OPTIONAL: attach unique conversion identifier to conversions
    // _pa.revenue = "19.99"; // OPTIONAL: attach dynamic purchase values to conversions
    // _pa.productId = "myProductId"; // OPTIONAL: Include product ID for use with dynamic ads
    var pa = document.createElement('script'); pa.type = 'text/javascript'; pa.async = true;
    pa.src = ('https:' == document.location.protocol ? 'https:' : 'http:') + "//tag.marinsm.com/serve/517fd07cf1409000020002dc.js";
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(pa, s);
  })();
</script>