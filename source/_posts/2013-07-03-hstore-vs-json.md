--- 
layout: post
title: hstore vs. JSON - Which to use in Postgres
tags: 
- Postgres, SQL, PostgreSQL
categories: [Postgres, SQL, PostgreSQL]
type: post
published: true
comments: false
---

If you're deciding what to put in [Postgres and what not to](http://www.amazon.com/Seven-Databases-Weeks-Modern-Movement/dp/1934356921?tag=mypred-20), consider that Postgres can be a [perfectly good schema-less database](/2012/06/11/schemaless-django/). Of course as soon as people realized this then the common comes a question, is hstore or JSON better. Which do I use and in what cases. Well first, if you're not familiar check out some previous material on them:

* [hstore on PostgresGuide](http://www.postgresql.org/docs/9.2/static/hstore.html)
* [hstore in Postgres docs](http://www.postgresql.org/docs/9.2/static/hstore.html)
* [hstore with Django](http://www.craigkerstiens.com/2012/06/11/schemaless-django/)
* [JSON datatype](http://wiki.postgresql.org/wiki/What's\_new\_in\_PostgreSQL\_9.2\#JSON\_datatype)
* [JavaScript support in Postgres](https://postgres.heroku.com/blog/past/2013/6/5/javascript_in_your_postgres/)

If you're already up to date with both of them, but still wondering which to use lets dig in. 

<!--more-->

### hstore

hstore is a key value store directly within your database. Its been a common favorite of mine and has been for some time. hstore gives you flexibility when working with your schema, as you don't have to define models ahead of time. Though its two big limitations are that 1. it only deals with text and 2. its not a full document store meaning you can't nest objects. 

Though major benefits of hstore include the ability to index on it, robust support for various operators, and of course the obvious of flexibility with your data. Some of the basic operators available include:

Return the value from column`foo` for key `bar`:

    foo->'bar'

Does the specified column `foo` contain a key `bar`:

    foo?'bar'

Does the specified column `foo` contain a value of `baz` for key `bar`:

    foo@>'bar->baz'

Perhaps one of the best parts of hstore is that you can index on it. In particular Postgres `gin` and `gist` indexes allow you to index all keys and values within an hstore. A talk by [Christophe Pettus](http://www.twitter.com/XoF) of PgExperts actually highlights some [performance details of hstore with indexes](http://thebuild.com/presentations/pg-as-nosql-pgday-fosdem-2013.pdf). To give away the big punchline in several cases hstore with gin/gist beats mongodb in performance.

### json

JSON in contrast to hstore is a full document datatype. In addition to nesting objects you have support for more than just text (read numbers). As you insert JSON into Postgres it will automatically ensure its valid JSON and error if its well not. JSON gets a lot better come Postgres 9.3 as well with [some built in operators](http://www.postgresql.org/docs/devel/static/functions-json.html). Though if you need more functionality in it today you should look at [PLV8](https://code.google.com/p/plv8js/wiki/PLV8).

### Which to Use

So which do you actually want to use in your application? If you're already using JSON and simply want to store it in your database then the JSON datatype is often the correct pick. However, if you're just looking for flexibility with your data model then hstore is likely the path you want to take. hstore will give you much of the flexibility you want as well as a good ability to query your data in a performant manner. Of course much of this starts to change in Postgres 9.3.