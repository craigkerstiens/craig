--- 
layout: post
title: The best Postgres feature you're not using – CTEs aka WITH clauses
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

SQL by default isn't typically friendly to dive into, and especially so if you're reading someone else's already created queries. For some reason most people throw out principles we follow in other languages [such as commenting](http://www.craigkerstiens.com/2013/07/29/documenting-your-postgres-database/) and composability just for SQL. I was recently reminded of a key feature in Postgres that most don't use by [@timonk](http://www.twitter.com/timonk) highlighting it in his AWS Re:Invent Redshift talk. The simple feature actually makes SQL both readable and composable, and even for my own queries capable of coming back to them months later and understanding them, where previously they would not be.

The feature itself is known as CTEs or common table expressions, you may also here it referred to as `WITH` clauses. The general idea is that it allows you to create something somewhat equivilant to a view that only exists during that transaction. You can create multiple of these which then allow for clear building blocks and make it simple to follow what you're doing. 

<!--more-->

Lets take a look at a nice simple one:

    WITH users_tasks AS (
      SELECT 
             users.email,
             array_agg(tasks.name) as task_list,
             projects.title
      FROM
           users,
           tasks,
           project
      WHERE
            users.id = tasks.user_id
            projects.title = tasks.project_id
      GROUP BY
               users.email,
               projects.title
    )

Using this I could now just append some basic other query on to the end that references this CTE `users_tasks`. Something akin to:

    SELECT *
    FROM users_tasks;

But where it becomes more interesting is chaining these together. So while I have all tasks assigned to each user here, perhaps I want to then find which users are responsible for more than 50% of the tasks on a given project, thus being the bottleneck. To oversimplify this we could do it a couple of ways, total up the tasks for each project, and then total up the tasks for each user per project:

    total_tasks_per_project AS (
      SELECT 
             project_id,
             count(*) as task_count
      FROM tasks
      GROUP BY project_id
    ),

    tasks_per_project_per_user AS (
      SELECT 
             user_id,
             project_id,
             count(*) as task_count
      FROM tasks
      GROUP BY user_id, project_id
    ),

Then we would want to combine and find the users that are now over that 50%:

    overloaded_users AS (
      SELECT tasks_per_project_per_user.user_id,

      FROM tasks_per_project_per_user,
           total_tasks_per_project
      WHERE tasks_per_project_per_user.task_count > (total_tasks_per_project / 2)
    )

Now as a final goal I'd want to get a comma separated list of tasks of the overloaded users. So we're simply giong to join against that `overloaded_users` and our initial list of `users_tasks`. Putting it all together it looks somewhat long, but becomes much more readable. And as a bonus I layered in some comments.

    --- Created by Craig Kerstiens 11/18/2013
    --- Query highlights users that have over 50% of tasks on a given project
    --- Gives comma separated list of their tasks and the project


    --- Initial query to grab project title and tasks per user
    WITH users_tasks AS (
      SELECT 
             users.id as user_id,
             users.email,
             array_agg(tasks.name) as task_list,
             projects.title
      FROM
           users,
           tasks,
           project
      WHERE
            users.id = tasks.user_id
            projects.title = tasks.project_id
      GROUP BY
               users.email,
               projects.title
    ),
    
    --- Calculates the total tasks per each project
    total_tasks_per_project AS (
      SELECT 
             project_id,
             count(*) as task_count
      FROM tasks
      GROUP BY project_id
    ),

    --- Calculates the projects per each user
    tasks_per_project_per_user AS (
      SELECT 
             user_id,
             project_id,
             count(*) as task_count
      FROM tasks
      GROUP BY user_id, project_id
    ),

    --- Gets user ids that have over 50% of tasks assigned
    overloaded_users AS (
      SELECT tasks_per_project_per_user.user_id,

      FROM tasks_per_project_per_user,
           total_tasks_per_project
      WHERE tasks_per_project_per_user.task_count > (total_tasks_per_project / 2)
    )

    SELECT 
           email,
           task_list,
           title
    FROM 
         users_tasks,
         overloaded_users
    WHERE
          users_tasks.user_id = overloaded_users.user_id

CTEs won't always be quite as performant as optimizing your SQL to be as concise as possible. In most cases I have seen performance differences smaller than a 2X difference, this tradeoff for readability is a nobrainer as far as I'm concerned. And with time the Postgres optimizer should continue to get better about such performance. 

As for the verbosity, yes I could have done this query in probably 10-15 lines of very concise SQL. Yet, most may not be able to understand it quickly if at all. Readability is huge when it comes to SQL to ensure its doing the right thing. SQL will almost always tell you an answer, it just may not be to the question you think you're asking. Ensuring your queries can be reasoned about is critical to ensuring accuracy and CTEs are one great way of accomplishing that.