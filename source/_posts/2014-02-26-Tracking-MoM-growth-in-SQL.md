--- 
layout: post
title: Tracking Month over Month Growth in SQL
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

In analyzing a business I commonly look at reports that have two lenses, one is by doing various cohort analysis. The other is that I look for Month over Month or Week over Week or some other X over X growth in terms of a percentage. This second form of looking at data is relevant when you're in a SaaS business or essentially anythign that does recurring billing. In such a business focusing on your MRR and working on [growing your MRR is how success can often be measured](http://www.amazon.com/dp/B003XVYKRW?tag=mypred-20). 

<!--more-->

I'll jump write in, first lets assume you have some method of querying your revenue. In this case you may have some basic query similar to:

    SELECT date_trunc('month', mydate) as date, 
           sum(mymoney) as revenue
    FROM foo
    GROUP BY date
    ORDER BY date ASC;

This should give you a nice clean result:

     date                   | revenue  
    ------------------------+----------
     2013-10-01 00:00:00+00 | 10000    
     2013-11-01 00:00:00+00 | 11000    
     2013-12-01 00:00:00+00 | 11500    

Now this is great, but the first thing I want to do is start to see what my percentage growth month over month is. Surprise, surprise, I can do this directly in SQL. To do so I'll use a [window function](http://postgresguide.com/tips/window.html) and then use the [lag function](http://www.postgresql.org/docs/9.3/static/functions-window.html). According to the Postgres docs

*lag(value any [, offset integer [, default any ]]) same type as value returns value evaluated at the row that is offset rows before the current row within the partition; if there is no such row, instead return default. Both offset and default are evaluated with respect to the current row. If omitted, offset defaults to 1 and default to null*

Essentially it orders it based on the [window function](http://www.postgresql.org/docs/9.3/static/tutorial-window.html) and then pulls in the value from the row before. So in action it looks something like:

    SELECT date_trunc('month', mydate) as date, 
           sum(mymoney) as revenue,
           lag(mymoney, 1) over w previous_month_revenue
    FROM foo
    WINDOW w as (order by date)
    GROUP BY date
    ORDER BY date ASC;

Combining to actually make it a bit more pretty (with some casting to a numeric and then formatting a bit) in terms of a percentage:

    SELECT date_trunc('month', mydate) as date, 
           sum(mymoney) as revenue,
           round((1.0 - (cast(mymoney as numeric) / lag(mymoney, 1) over w)) * 100, 1) myVal_growth
    FROM foo
    WINDOW w as (order by date)
    GROUP BY date
    ORDER BY date ASC;

And you finally get a nice clean output of your month over month growth directly [in SQL](http://www.amazon.com/dp/B0043EWUQQ?tag=mypred-20):

     date                   | revenue  | growth
    ------------------------+----------+--------
     2013-10-01 00:00:00+00 | 10000    |   null 
     2013-11-01 00:00:00+00 | 11000    |   10.0 
     2013-12-01 00:00:00+00 | 11500    |   4.5 
