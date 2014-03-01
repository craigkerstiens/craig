--- 
layout: post
title: Postgres Indexing - A collection of indexing tips
tags: 
- Postgres, SQL
categories: [Postgres, SQL]
type: post
published: true
comments: false
---

Even from intial reviews of my previous post on expression based indexes I received a lot of questions and feedback around many different parts of indexing in Postgres. Here's a mixed collection of valuable tips and guides around much of that.

### Unused Indexes

In an earlier tweet I joked about some SQL that would generate the SQL to add an index to every column:

    # SELECT 'CREATE INDEX idx_' 
        || table_name || '_' 
        || column_name || ' ON ' 
        || table_name || ' ("' 
        || column_name || '");' 
      FROM information_schema.columns;
                          ?column?
    ---------------------------------------------------------------------
     CREATE INDEX idx_pg_proc_proname ON pg_proc ("proname");
     CREATE INDEX idx_pg_proc_pronamespace ON pg_proc ("pronamespace");
     CREATE INDEX idx_pg_proc_proowner ON pg_proc ("proowner");

<!-- more -->

The reasoning behind this is guessing whether an index will be helpful can be a bit hard within Postgres. So the easy solution is to add indexes to everything, then just observe if they're being used. *Of course you want to add it to all tables/columns because you never know if core of Postgres may be missing some needed ones*

As included with the [pg-extras plugin for Heroku](https://github.com/heroku/heroku-pg-extras) you can run a query to show you all unused indexes. On Heroku simply install the plugin the run `heroku pg:unused_indexes` to show the size and number of times an index scan has been used. On a non Heroku Postgres database you can run:

    # SELECT
        schemaname || '.' || relname AS table,
        indexrelname AS index,
        pg_size_pretty(pg_relation_size(i.indexrelid)) AS index_size,
        idx_scan as index_scans
      FROM pg_stat_user_indexes ui
      JOIN pg_index i ON ui.indexrelid = i.indexrelid
      WHERE NOT indisunique AND idx_scan < 50 AND pg_relation_size(relid) > 5 * 8192
      ORDER BY pg_relation_size(i.indexrelid) / nullif(idx_scan, 0) DESC NULLS FIRST,
      pg_relation_size(i.indexrelid) DESC;
              table      |                       index                | index_size | index_scans
    ---------------------+--------------------------------------------+------------+-------------
     public.grade_levels | index_placement_attempts_on_grade_level_id | 97 MB      |           0
     public.observations | observations_attrs_grade_resources         | 33 MB      |           0
     public.messages     | user_resource_id_idx                       | 12 MB      |           0
    (3 rows)

### Costs of Indexing

There are really a couple of primary costs when it comes to indexing your data. The first is the overall size of the index. Indexes take size on disk, fortunately in most cases disk is pretty cheap. If you're limited on disk size and not on your current performance then its pretty clear the trade-off you want to take. If you do need to get the size of your index you can do that by running:

    # SELECT pg_size_pretty(pg_total_relation_size('idx_name'));

The harder trade off to look at is the cost in terms of throughput. As your data comes in there's a cost for maintaining that index as the data within it has to be computed. If you're doing crazy regex's in your index then you can expect this to have an impact on your throughput. 

### Composite Indexes vs. Multiple Indiviual Indexes

A composite index is an index that includes multiple columns. Given an example table of purchases:

    # \d purchases
                   Table "public.purchases"
    Column    |            Type             | Modifiers
    -------------+-----------------------------+-----------
     id          | integer                     | not null
     item        | integer                     |
     quantity    | integer                     |
     color       | integer                     |

You might want to add an index on item and quantity together. You can do this with:

    CREATE INDEX idx_purchases_item_quantity_color ON purchases (item, quantity, color)

From now on if you included item and quantity in a query its likely it would use this index just as it would if you used item, quantity and color. If you have a large varied set of data within each of these such an index can prove very useful. The caveat is that if you're querying against only quantity and color then this index is useless, it **must** include the item column.

In contrast if you have three individual indexes Postgres may combine these or simply use one that would be the most efficient out of the three.

    CREATE INDEX idx_purchases_item ON purchases (item);
    CREATE INDEX idx_purchases_quantity ON purchases (quantity);
    CREATE INDEX idx_purchases_color ON purchases (color);

Of course in this case if you query any individual column it would use the index if appropriate. 

### What Else

What else do you want to know about Postgres Indexing? Drop me a line [craig.kerstiens at gmail.com](mailto:craig.kerstiens@gmail.com) or hop over to [Postgres Guide](http://www.postgresguide.com) and [read a little there](http://postgresguide.com/performance/indexes.html) or even contribute some articles of your own.

<!-- Perfect Audience - why postgres - DO NOT MODIFY -->
<img src="http://ads.perfectaudience.com/seg?add=691030&t=2" width="1" height="1" border="0" />
<!-- End of Audience Pixel -->