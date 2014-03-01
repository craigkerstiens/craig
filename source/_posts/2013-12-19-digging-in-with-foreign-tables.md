--- 
layout: post
title: Digging in with Foreign Tables
tags: 
- Postgres, SQL, PostgreSQL
categories: [Postgres, SQL, PostgreSQL]
type: post
published: false
comments: false
---

I wrote a couple months back about exploring FDWs. Its become quite clear to me, despite still having ample room for improvement, they're not getting enough attention. Foreign data wrappers are perhaps better thought of as a foreign table, or even better yet as a view into some remote data source. They don't take care of auto-updating or syncing data, thats all up to you, but it gives you a straight forward mapping to work with remote data easier. 

The first step in working with FDWs is getting them setup. I wrote an earlier post on how to do this manually. And if you're on Heroku theres an even easier solution if you want to setup a mapping entirely from one DB to another. The [pg-extras CLI plugin]() has a command `fdwsql` which will generate the SQL to map all the tables for you. To run it simply specify the prefix app and database:

    heroku pg:fdwsql yourprefix APP::DATABASE_URL

This will generate a lot of SQL. From here you'll want to connect to the database where you want those foreign tables to be visible. Then run all the SQL. This will create all the foreign tables, this will mostly look just like another view or table to you in `\d`.

### Tips on working with them

For the most part you can work with your foreign tables just like any other view or table. You can insert into them, read from them, join against them. Though currently foreign tables have some performance limitations, such as when joining it may return a lot more data than you expect then join. To make your performance a bit more ideal you can follow a few basic principles.

Lets look at some example tables to highlight this:

    > \d 
     users
     todos

In this case users is local and the todos are a foreign table. Looking at each of the schemas we have something like you might expect:

    > \d users
                       Table "public.users"
        Column    |            Type             | Modifiers
     -------------+-----------------------------+-----------
      id          | integer                     | not null
      email       | text                        |
      created_at  | timestamp without time zone |
     Indexes:
         "users_pkey" PRIMARY KEY, btree (id)
         "users_created" btree (created_at)


    > \d todo
                   Foreign Table "public.todo"
        Column    |            Type             | Modifiers
     -------------+-----------------------------+-----------
      id          | integer                     | not null
      user_id     | integer                     |
      desc        | text                        |
      created_at  | timestamp without time zone |
      status      | boolean                     |
     Indexes:
         "users_pkey" PRIMARY KEY, btree (id)
         "todo_created" btree (created_at)

