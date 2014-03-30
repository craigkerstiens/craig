--- 
layout: post
title: A year's look at Postgres
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

A couple years back I started more regularly blogging, though I've done this off and on before, this time I kept some regularity. A common theme started to emerge with some content on Postgres about once a month because most of what was out there was much more reference oriented. A bit after that I connected with [petercooper](http://www.twitter.com/peterc), who runs quite a few weekly email newsletters. As someone thats been interested helping give others a good reason to create content the obvious idea of [Postgres Weekly](http://www.postgresweekly.com) emerged.

Since then we've now had the newsletter running for over a year, helped surface quite a bit of content, and grown to over 5,000 subscribers. First if you're not subscribed, then go [subscribe now](http://www.postgresweekly.com).

And if you need some inspiration or just want to reminisce with me... here's a look back at a few highlights over the past year:

<!--more-->

### The inagural issue

#### [Postgres: The Bits You Haven't Found](http://postgres-bits.herokuapp.com/?utm_source=craigkerstiens&utm_medium=blog)

A slide-deck from a presentation at Heroku's Waza conference that highlights many of the more unknown and rare features within Postgres, including 'WITH', arrays, pub/sub, and hstore.

#### [Open Source Release:postgresql-hll](http://blog.aggregateknowledge.com/2013/02/04/open-source-release-postgresql-hll/?utm_source=craigkerstiens&utm_medium=blog)

Aggregate Knowledge released Postgres HyperLogLog, which is a new Postgres datatype hll that strikes a balance between HyperLogLog and a simple set. This data type solves the problem of calculating uniques for a given data set efficiently both in performance and storage.

*The above is still one of my favorite extensions that most of the world doesn't know about*

#### [How I Work with Postgres - Psql, My PostgreSQL Admin](http://www.craigkerstiens.com/2013/02/13/How-I-Work-With-Postgres/?utm_source=craigkerstiens&utm_medium=bloga)

A common question for anyone new or even experienced with Postgres is whats the best editor out there? Most when they are asking this are asking for a GUI editor, this post highlights much of the power in the CLI 'psql' editor.

### A mix of notable entries

#### [Issue 6](http://postgresweekly.com/issues/6) [Dissecting PostgreSQL CVE-2013-1899](http://blog.blackwinghq.com/2013/04/08/2/?utm_source=craigkerstiens&utm_medium=blog)

After the heavily publicized and very serious security vulnerability was patched last week Blackwing intelligence took the chance to dig in. Read more on the details of the vulnerability such as what damage can be done and the basics of how its exploitable.

#### [Issue 16](http://postgresweekly.com/issues/16) [Tom Lane Explains Query Planner video](http://www.justin.tv/sfpug/b/419326732?utm_source=craigkerstiens&utm_medium=blog)

Tom Lane, one of the major contributors to Postgres and on the Postgres core team, was in San Francisco last week and gave a talk at the SF Postgres Users Group. Here's the video from the talk where Tom explains the innards of the PostgreSQL query planner. Whether you're a noob or a knowledgable Postgres user this is a must watch.

#### [Issue 35](http://postgresweekly.com/issues/35) [Top 10 psql ‘\’ commands I use](http://www.chesnok.com/daily/2013/11/06/top-10-psql-commands-i-use/)

Psql is incredibly powerful, but the list of options within it can be overwhelming. Heres a straight forward list of @selenamarie’s top 10 commands.

#### [Issue 38](http://postgresweekly.com/issues/38) [Everyday Postgres: Tuning a brand-new server - the 10 minute edition](http://www.chesnok.com/daily/2013/11/13/everyday-postgres-tuning-a-brand-new-server-the-10-minute-edition/?utm_source=craigkerstiens&utm_medium=blog)

After a fresh install, there are probably a few knobs you want to tweak on Postgres. If you’re new to doing this, it can be a bit overwhelming. Here’s a quick primer on tuning a brand new server to be more properly configured.

### [And the latest issue](http://postgresweekly.com/issues/51)

Which highlights a wealth of information on [jsonb](http://postgresweekly.com/issues/51), and a bit of various knowledge touching on [cluster](http://hans.io/blog/2014/03/25/postgresql_cluster/index.html?utm_source=craigkerstiens&utm_medium=blog), [recursive queries with CTEs](http://practiceovertheory.com/blog/2013/07/12/recursive-query-is-recursive/?utm_source=craigkerstiens&utm_medium=blog), and [range types](http://www.davidhampgonsalves.com/Postgres-ranges/?utm_source=craigkerstiens&utm_medium=blog). 

### In conclusion

What did you like? Any favorites I missed? What would you like to see more of? Let me know [@craigkerstiens](http://www.twitter.com/craigkerstiens) or at [craig.kerstiens at gmail.com](mailto:craig.kerstiens@gmail.com)