--- 
layout: post
title: Writing more legible SQL
tags: Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

A number of times in a crowd I've asked how many people enjoy writing SQL, and often there's a person or two. The follow up is how many people enjoy reading other people's SQL and that's unanimously 0. The reason for this is that so many people write bad SQL. It's not that it doesn't do the job, it's just that people don't tend to treat SQL the same as other languages and don't follow strong code formatting guidelines. So, of course here's some of my own recommendations on how to make SQL more readable.

<!--more-->

### One thing per line

Only put a single column/table/join per line. This is going to make for slightly more verbose SQL, but it will be easier to read and edit.. Here's a basic example:

    SELECT foo,
           bar
    FROM baz

### Align your projections and conditions

You can somewhat see this in the above with `foo` and `bar` being on the same line. This is reasonably common for columns you're selecting, but it's not applied as often in `AND` or `GROUP BY` clauses. As you can see there is a difference though between:

    SELECT foo,
           bar
    FROM baz
    WHERE foo > 3
    AND bar = 'craig.kerstiens@gmail.com'

And a cleaner version:

    SELECT foo,
           bar
    FROM baz
    WHERE foo > 3
      AND bar = 'craig.kerstiens@gmail.com'

### Use column names when grouping/ordering

This is personally an awful habit of mine, but it is extremely convenient to just order by the column number. In the above query we could just `ORDER BY 1`. This is especially easy when column 1 may be something like SUM(foo). However, ensuring you explicitly `ORDER BY SUM(foo)` will help limit any misunderstanding of the data.

### Comments

You comment your code all the time, yet so few seem to comment their queries. A simple `--` allows you to inline a comment, perhaps where there's some oddities to what you're joining or just anywhere it may need clarification. You can of course [go much further](/2013/07/29/documenting-your-postgres-database/), but at least some basic level of commenting should be required.

### Casing

As highlighted in these examples, having a standard for how you case your queries is especially handy. Sticking with all SQL keywords in caps allows you to easily parse what is SQL and what are columns or literals that you're using in queries.

### CTEs

First, yes they can be an optimisation boundary. But they can also make your query much more read-able and prevent you from doing the wrong thing because you couldn't reason about a query. 

For those unfamiliar CTEs are like a view that exist just for the duration of that query being executed. You can have them reference previous CTEs so you can gradually build on them, much like you would code blocks. I won't repeat too much of what [I've already written about them](/2013/11/18/best-postgres-feature-youre-not-using/), but if you're unfamiliar with them or not using them [they are a must](/2013/11/18/best-postgres-feature-youre-not-using/). CTEs are easily one of the few pieces of SQL that I use on a daily basis. 

### Conclusion

Of course this isn't the only way to make your SQL more readable and this isn't an exhaustive list. But hopefully you find these tips helpful, and for your favorite tip that I missed... let me know about it [@craigkerstiens](http://www.twitter.com/craigkerstiens).

*A special thanks to [@Case](http://www.twitter.com/Case) for reviewing.*

<script type="text/javascript">
  (function() {
    window._pa = window._pa || {};
    var pa = document.createElement('script'); pa.type = 'text/javascript'; pa.async = true;
    pa.src = ('https:' == document.location.protocol ? 'https:' : 'http:') + "//tag.marinsm.com/serve/517fd07cf1409000020002dc.js";
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(pa, s);
  })();
</script>