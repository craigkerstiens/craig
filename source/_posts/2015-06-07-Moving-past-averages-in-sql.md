--- 
layout: post
title: Moving past averages in SQL (Postgres) – Percentiles
tags: Postgres
categories: [Postgres]
type: post
published: true
comments: false
---

Often when you're tracking a metric for the first time you take a look at your average. For example what is your ARPU - Average Revenue Per User. In theory this tells you if you can acquire new user how much you'll make off that user. Or maybe what's your average life time value of a customer. Yet, many that are more familiar looking and extracting meaning from data median or a few different looks at [percentiles can be much more meaningful](http://apmblog.dynatrace.com/2012/11/14/why-averages-suck-and-percentiles-are-great/). 

<!--more-->

And while you can very easily get the `AVG` in Postgres, with a small amount more effort you can report on percentiles as well. Window functions have been around for some time in Postgres. They allow you to order your result set over a certain group. The most basic example is if you want to order by date, but know which one falls at place 10 in order you can use a window function and project out the `rank()`. 

Beyond outputting the rank yourself and doing extra manipulation Postgres has some great utilities to make the most common uses even easier. Being able to compute things such as the perc 95 directly on the data, or lay out for every record in the result where it falls within a percentile is hugely useful. Let's take a look:

Assuming you have a table called purchases, which has a total in it we could try:

    SELECT id,
           total,
           ntile(100) OVER (ORDER BY total) AS perc_rank
    FROM purchases

This would give us something like:

        id    |  total  | perc_rank
    ----------|---------|-----------
       264    |  12034  |    100
       643    |  11830  |    100
    ...
    ...
       304    |   751   |     95

What this would tell us is we have less than 5% of our purchases that have a total over 751. From here you can start to dig in and extract all sorts of different meanings, and by doing directly in SQL you're closer to the data and have one less processing step.

Percentiles get even more fun with the ordered set functions that came out in [Postgres 9.4](/2014/02/02/Examining-PostgreSQL-9.4/). They even allow you to project out hypothetical values in certain cases. For now I'd encourage adding ntile to your toolbox anytime you're analyzing average or medians it will make your world a bit better, and then consider exploring further on the [ordered set functions](http://www.postgresql.org/docs/9.4/static/functions-aggregate.html#FUNCTIONS-ORDEREDSET-TABLE)