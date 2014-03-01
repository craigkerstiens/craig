--- 
layout: post
title: Explaining your PostgreSQL data
tags: 
- Postgres, SQL
categories: [Postgres, SQL]
type: post
published: true
comments: false
---

I've written a bit before about [understanding the output](http://www.craigkerstiens.com/2013/01/10/more-on-postgres-performance/) from `EXPLAIN` and `EXPLAIN ANALYZE` in PostgreSQL. Though understandably getting a grasp on execution plans could probably use some more guidance. Yet, this time around I'm taking a bit of a cop out and highlighting a few tools instead of documenting myself, which I've done in a talk I've frequently given [Postgres Demystified](https://speakerdeck.com/craigkerstiens/postgres-demystified-1).

![Explain explained](http://f.cl.ly/items/2Y0A0H2B2q3C0622261C/Screenshot_6_13_13_9_57_AM.png)

<!--more-->

### Getting at the Data

The first small thing you can do is actually retrieve the data in JSON form. By adding in `(format json)` right after your `EXPLAIN` or `EXPLAIN ANALYZE` command it'll as you'd expect return it in JSON. To give an example:

    # EXPLAIN SELECT * FROM users LIMIT 1;  
                        QUERY PLAN                          
    -------------------------------------------------------------- 
     Limit  (cost=0.00..0.03 rows=1 width=812) 
       ->  Seq Scan on users  (cost=0.00..1.50 rows=50 width=812)
     (2 rows)

Then in JSON format:

    EXPLAIN (format json) SELECT * FROM users LIMIT 1;
           QUERY PLAN                 
    ------------------------------------------------ 
     [                                        +
       {                                      +
         "Plan": {                            +       
           "Node Type": "Limit",              +       
           "Startup Cost": 0.00,              +       
           "Total Cost": 0.03,                +       
           "Plan Rows": 1,                    +       
           "Plan Width": 812,                 +
           "Plans": [                         +
             {                                +
               "Node Type": "Seq Scan",       +
               "Parent Relationship": "Outer",+
               "Relation Name": "users",      +
               "Alias": "users",              +
               "Startup Cost": 0.00,          +
               "Total Cost": 1.50,            +
               "Plan Rows": 50,               +
               "Plan Width": 812              +
             }                                +
           ]                                  +
         }                                    +
       }                                      +
     ]
    (1 row)

While its on my list to build some interesting apps by pulling in the JSON input, others may be equally as interested in taking advantage of this data in its JSON form. If you take a shot at building something with this output, as always I'd love to hear about it - [craig.kerstiens@gmail.com](mailto:craig.kerstiens@gmail.com)

### Despez

Of course if you're itch isn't in better tools for Postgres, you may just want to have a solution that works today. While its not perfect, one of the best ones out there is [Dezpez's explain tool](http://explain.depesz.com/). You can take any execution plan and paste it in and get some better visual representation of the result. You can also [share them as well](http://explain.depesz.com/s/vL1).