--- 
layout: post
title: Postgres and Node - Hands on using Postgres as a Document Store with MassiveJS
tags: Postgres, PostgreSQL, Node
categories: [Postgres, PostgreSQL, Node]
type: post
published: true
comments: false
---

JSONB in Postgres is absolutely awesome, but it's taken a little while for libraries to come around to make it as useful as would be ideal. For those not following along with Postgres lately, here's the quick catchup for it as a NoSQL database.

* In Postgres 8.3 over 5 years ago Postgres received [hstore a key/value](http://www.craigkerstiens.com/2013/07/03/hstore-vs-json/) store directly in Postgres. It's big limitation was it was only for text
* In the years after it got GIN and GiST indexes to make queries over hstore extremely fast indexing the entire collection
* In Postgres 9.2 we got JSON... sort of. Really this way only text validation, but allowed us to create some [functional indexes](http://www.craigkerstiens.com/2013/05/29/postgres-indexes-expression-or-functional-indexes/) which were still nice.
* In Postgres 9.4 we got JSONB - the B stands for Better according to [@leinweber](http://www.twitter.com/leinweber). Essentially this is a full binary JSON on disk, which can perform as fast as other NoSQL databases using JSON. 

<!--more-->

This is all great, but when it comes to using JSON you need a library that plays well here. As you might have guessed it from [my previous post this is where MassiveJS comes in](http://www.craigkerstiens.com/2015/11/30/massive-node-postgres-an-overview-and-intro/). Most ORMs take a more legacy approach to [how they work with the database](http://www.craigkerstiens.com/2014/01/24/rethinking-limits-on-relational/), in contrast the other side of the world believes in document only storage way is the future. In contrast Postgres believes there is a time and place for everything, just like Massive, except it believes Postgres is the path [just as I do](http://www.craigkerstiens.com/2012/04/30/why-postgres/). 

Alright, enough context, let's take a look. 

### Getting all setup

First go ahead and create a database, let's call it massive, and then let's connect to it and create our example table:

    $ createdb massive
    $ psql massive
    # create table posts (id serial primary key, body jsonb);

Now that we've got our database setup let's seed it with some data. If you want you can simple hop over to the github repo and pull it down then run `node load_json.js` to load the example data. A quick look at it, given an `example.json` file we're going to iterate over it. For each record in there, we're going to call saveDoc. Based on our table which has a unique id key and a body jsonb field it'll simply save our JSON document into that table:

    var parsedJSON = require('./example.json');
    
    for(i = 0; i < parsedJSON.posts.length; i++) {
        db.saveDoc("posts", parsedJSON.posts[1], function(err,res){});
    };

*If you want to just take a look at this [github repo](https://github.com/craigkerstiens/json_node_example), once you create a database you can run `node load_json.js` to seed it.*

### Why JSON at all?

JSON data is all over the place, in many cases it's fast and flexible and allows you to move more quickly. Yes, much of the time normalizing your data can be useful, but there is something to be said for expediency saving some data and querying across it. Querying across some giant document also used to be much more expensive, but now with JSONB and it's indexes that can be extremely fast. 

### Querying

So how do we go about querying? Well it's pretty simple with Massive, they provide a nice `findDoc` function to let you just search for contents of a specific key within the document. Let's say I wanted to pull back all posts that are in the Postgres category, well it's as simple as:

    db.posts.findDoc({title : 'Postgres'}, function(err,docs){
        console.log(docs);
    });

The real beauty of this is if you added a GIN index (which will index the entire document) this query will be [quite performant](http://obartunov.livejournal.com/175235.html).

*Just make sure to add your GIN index*:

    CREATE INDEX idx_posts ON posts USING GIN(body jsonb_path_ops); 
    CREATE INDEX idx_posts_search ON posts USING GIN(search);  

But even better, with Massive it'll automatically add these for you if you just start saving docs. It will automatically create the table and appropriate indexes, just doing the correct thing out of the box.

### Full text and JSON

Cool, so you can do an exact look up. Which is great when you're matching a category... which could be easily normalized. It's great when you're matching numbers, which also could likely reside in their own column. But what about when you're searching over a large document, or a set of keys within some document which may require several joins, or indeterminate data structure, well you may want to search for the presence of that string at all. As you may have guessed this is quite trivial.

    db.posts.searchDoc({
        keys : ["title", "category"],
        term : ["Postgres"]
    }, function(err,docs){
        console.log(docs);
    })

Hopefully it's pretty straight forward, but to be very clear. Call out the document table you want to search, then the keys you'll want to include in the search, then the term. This will search for any place the contents that string are found in matching values for those keys. 

Which will nicely yield the expected documents:

    [ { link: 'http://www.craigkerstiens.com/2015/05/08/upsert-lands-in-postgres-9.5/',
        title: 'Upsert Lands in PostgreSQL 9.5 – a First Look',
        category: 'Postgres',
        comments: [ [Object] ],
        id: 2 },
      { link: 'http://www.craigkerstiens.com/2015/11/30/massive-node-postgres-an-overview-and-intro/',
        title: 'Node, Postgres, MassiveJS - a Better Database Experience',
        id: 3 } ]

### In conclusion

While Massive isn't perfect, its approach to storing queries in files, using the schema vs. having to define your models in code and the database, and it's smooth document integration makes it a real contender as a better database library when working with Node. Give it a try and let me know your thoughts. 
