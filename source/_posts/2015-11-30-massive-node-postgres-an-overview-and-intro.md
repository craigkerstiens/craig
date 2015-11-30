--- 
layout: post
title: Node, Postgres, MassiveJS - A better database experience
tags: Postgres, PostgreSQL, Node
categories: [Postgres, PostgreSQL, Node]
type: post
published: true
comments: false
---

First some background–I've always had a bit of a love hate relationship with ORMs. ORMs are great for basic crud applications, which inevitably happens at some point for an app. The main two problems I have with ORMs is: 

1. They treat all databases as equal (yes, this is a little overgeneralized but typically true). They claim to do this for database portability, but in reality an app still can't just up and move from one to another.
2. They don't handle complex queries well at all. As someone that sees SQL as a very powerful language, taking away all the power just leaves me with pain.

*Of course these aren't the [only issues](https://kev.inburke.com/kevin/faster-correct-database-queries/) with them, just the two ones I personally run into over and over.*

In some playing with Node I was optimistic to explore [Massive.JS](http://massive-js.readthedocs.org) as it seems to buck the trend of just imitating all other ORMs. My initial results–it makes me want to do more with Node just for this library. After all the power of a language is the ecosystem of libraries around it, not just the core language. So let's take a quick tour through with a few highlights of what makes it really great.

<!--more-->

### Getting setup

Without further adieu here's a quick tour around it. 

First let's pull down the example database from [PostgresGuide](http://postgresguide.com/setup/example.html) 

Then let's setup out Node app:

    $ npm init
    $ npm install massive --save


### Connecting and querying

Now let's try to connect and say query a user from within our database. Create the following as an `index.js` file, then run with `node index.js`:

    var massive = require("massive");
    var connectionString = "postgres://ckerstiens:@localhost/example";

    var db = massive.connectSync({connectionString : connectionString});

    db.users.find(1, function(err,res){
      console.log(res);
    });

Upon first run if you're like me and use the [PostgresGuide example database](http://postgresguide.com/setup/example.html) (which I now need to go back and tidy up), you'll get the following:

    db.users.find(1, function(err,res){
            ^
    TypeError: Cannot read property 'find' of undefined

I can't describe how awesome it is to see this. What's happening is when Massive loads up it's connecting to your database, checking what tables you have. In this case though because we don't have a proper primary key defined it doesn't load them. It could treat id as some magical field of course like Rails used to and ignore the need for an index, but instead it not only encourages a good database design but requires it. 

So let's go back and create our index in our database:

    $ psql example
    $ alter table users add primary key (id);

Alright now let's run our script again with `node index.js` and see what we have:

    { id: 1,
      email: 'john.doe@gmail.com',
      created_at: Thu Sep 24 2015 03:42:52 GMT-0700 (PDT),
      deleted_at: null }

Perfect! Now we're all connected and it even queried our database for us. Now let's take a few more look at some of the operators. 

### Running an arbitrary query

`db.run` will let me run any arbritrary SQL. An example such as `db.run("select 'hello'")` will produce [ { '?column?': 'hello' } ]. 

This makes it nice and easier for us to break out of the standard ORM model and just run SQL. 

### Find for quick look ups

Similar to so many other database tools `find` will offer you the most common quick look ups:

    $ db.users.find({email: 'jane.doe@gmail.com'}, function(err, res){console.log(res)});
    $ db.users.find({'created_at >': '2015-09-24'}, function(err, res){console.log(res)});

And of course there's a where operator for multiple conditions. 

### Structuring queries in your application

While in the next post I'll dig in deep to JSON, this is perhaps my favorite feature of Massive... It's design for pulling out queries into individudal SQL files. Simply create a `db` folder and put your SQL in there. Let's take the most basic example of our user email lookup and put it in `user_lookup.sql`
    
    SELECT *
    FROM users
    WHERE email = $1

Now back in our application we can run this and pass in a parameter to it:

    db.user_lookup(['jane.doe@gmail.com'], function(err,res){
      console.log(res);
    });

This separation of our queries from our code makes it easier to track them, view diffs, and even more so [create very readable SQL](http://www.craigkerstiens.com/2012/11/17/how-i-write-sql/).

### Up next

So sure, you can connect to a database, you can query some things. There were a couple of small but more novel things that we blew through in here. First is the fact I didn't have to define all my schema, it just knew it as [it really should](http://www.craigkerstiens.com/2014/01/24/rethinking-limits-on-relational/). The separation of SQL queries you'll custom write into files is simple, but will make for much more maintainable applications over the long term. And best of all is the JSON support, which I'll get to soon... 