--- 
layout: post
title: Rethinking the limits on relational databases
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

Theres a lot of back and forth on NoSQL databases. The unfortunate part with all the back and forth and unclear definitions of NoSQL is that many of the valuable learnings are lost. This post isn't about the differences in NoSQL definitions, but rather some of the huge benefits that do exist in whats often grouped into the schema-less world that could easily be applied to the relational world.

### Forget migrations

Perhaps the best thing about the idea of a schemaless database is that you can just push code and it works. Almost exactly five years ago Heroku shipped `git push heroku master` letting you simply push code from git and it just work. CouchDB and MongoDB have done similar for databases... you don't have to run `CREATE TABLE` or `ALTER TABLE` migrations before working with your database. There's something wonderful about just building and shipping your application without worrying about migrations.

<!--more-->

This is often viewed as a limitation of relational databases. Yet it doesn't really have to. You see even in schema-less database the relationships are still there, its just you're managing it at the application level. There's no reason higher level frameworks or ORMs couldn't handle the migration process. As it is today the process of adding a column to a relational database is quite straightforward in a sense where it doesn't introduce downtime and is capable of letting the developer still move quickly its just not automatically baked in.

    # Assuming a column thats referenced doesn't exist
    # Automatically execute relevant bits in your ORM
    # This isn't code meant for you to run 

    ALTER TABLE foo ADD COLUMN bar varchar(255); # This is near instant
    # Set your default value in your ORM
    UPDATE TABLE foo SET bar = 'DEFAULT VALUE' WHERE bar IS NULL;
    ALTER TABLE foo ALTER COLUMN bar NOT NULL;

Having Rails/Django/(Framework of your choice) automatically notice the need for a column to exist and make appropriate modifications you could work with it the same way you would managing a document relation in your code. Sure this is a manual painful process today, but theres no reason this can't be fully handled by PostgreSQL or directly within an ORM .

### Documents

The other really strong case for the MongoDB/CouchDB camp is document storage. In this case I'm going to equate a document directly to a JSON object. JSON itself is a wonderfully simply model that works so well for portability, and having to convert it within your application layer is well just painful. Yes Postgres has a JSON datatype, and the JSON datatype is continuing to be adopted now by many other relational databases. *I was shocked to hear that DB2 is getting support for JSON myself, while I expect improvements to come to it JSON was not at the top of my list*. 

And JSON does absolutely make sense as a data type within a column. But thats still a bit limiting as a full document store, what you want in those cases is any query result as a full JSON object. This is heavily undersold within Postgres that you can simply convert a full row to JSON with a [single function](http://www.postgresql.org/docs/9.3/static/functions-json.html) - `row_to_json`. 

Again having higher level frameworks take full advantage so that under the covers you can have your strongly typed tables, but a flexibility to map them to flexible JSON objects makes a great deal of sense here.

### Out of the box interfaces

This isn't a strict benefit of schema-less databases. Some schema-less databases have this more out of the box such as Couch where others less so. The concept of exposing a rest interface is not something new, and has been tried on top of relational databases a [few times over](http://htsql.org/). This is clearly something that does need to be delivered. The case for it is pretty clear, it reduces the work of people having to recreate admin screens and gives an easy onboarding process for noobs. 

Unfortunately there's not clear progress on this today for Postgres or other relational databases. In contrast other databases are delivering on this front often from day one :/

### Where to

Some of the shifts in schema-less or really in other databases in general are not so large they cannot be subsummed into a broader option. At the same time there are some strong merits such as the ones above which do take an active effort to deliver on expanding what is a "relational database". 