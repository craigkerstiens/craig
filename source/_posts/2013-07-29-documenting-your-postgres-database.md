--- 
layout: post
title: Documenting your PostgreSQL database
tags: 
- Postgres, SQL, PostgreSQL
categories: [Postgres, SQL, PostgreSQL]
type: post
published: true
comments: false
---

Just a few days ago I was surprised by what someone was doing with their database, and not in the typical horrifying travesty against mankind. Rather, it was a feature that while familiar with I'd never seen anyone fully take proper advantage of - `COMMENT` or describing tables. Postgres has a nice facility for you to provide a description for just about anything: 

* Table
* Column
* Function
* Schema
* View
* Index
* Etc.

<!--more-->

The specific use case was a database acting as a datamart pulling in data from multiple sources to be able to report against disparate data. Over the years I've seen this occur really one three ways, the first is that a limited set of people, typically one person, have knowledge over all the datasources and thus far the sole individual responsible for creating reports and answering questions of the data. The second, is wide open access to anyone that wishes for it. In this case you often have people asking questions of the data, and because they don't understand the relationships coming up to entirely wrong conclusions. The final approach is to create some external documentation, entity relationship diagrams, data dictionaries, etc. This last one often works okay enough, but often suffers from lack of updates and being too heavyweight. 

A better solution, and all around good process is simply documenting clearly within the database itself. Simply comment each table and column, just as you would outside of your DB then it can be quite clear when inside the database working interactivly:

    COMMENT ON TABLE products IS 'Products catalog';
    COMMENT ON COLUMN products.price is 'Current price of a single item purchased';

While an obvious example above naming even the most mundance columns can help create more accurate reports. Then of course when you want to inspect your DB its quite clear:

    \d+ users
    # \d+ users
                                         Table "public.users"
       Column   |            Type             | ... | Description
    ------------+-----------------------------+-...-+-----------------------------------------
     id         | integer                     | ... | auto serial pk
     first_name | character varying(50)       | ... | required first name of user
     last_name  | character varying(50)       | ... | required first name of user
     email      | character varying(255)      | ... | email address of account
     data       | hstore                      | ... | mix of data, city, state, gender
     created_at | timestamp without time zone | ... | when account was created, not confirmed
     updated_at | timestamp without time zone | ... | time any details were last updated
    Indexes:
        "idx_user_created" btree (date_trunc('day'::text, created_at))
    Has OIDs: no

But it doesn't necessarily have to stop there. Which actually brings me to one other item, you should be commenting your SQL just the same. SQL comments can be done easily by just starting a line with `--`, or you can have it at the end of the line with further info. Here's a nice example:

    -- Query aggregates all project names that have open past due tasks grouped by email
    SELECT 
      users.email,
      array_to_string(array_agg(projects.name), ',')) as projects # Aggregate all projects and separate by comma
    FROM
      projects,
      tasks,
      users
    -- A user has a project, which has tasks
    WHERE projects.id = tasks.project_id
      -- Check for tasks that are due before now and not done yet
      AND tasks.due_at > tasks.completed_at
      AND tasks.due_at < now()
      AND users.id = projects.user_id
    GROUP BY 
      users.email

You comment your code, why shouldn't you comment your database? 