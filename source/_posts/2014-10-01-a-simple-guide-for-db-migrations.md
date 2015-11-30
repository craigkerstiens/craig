--- 
layout: post
title: A simple guide for DB migrations
tags: Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

Most web applications will add/remove columns over time. This is extremely common early on and even mature applications will continue modifying their schemas with new columns. An all too common pitfall when adding new columns is setting a not null constraint in Postgres. 

<!--more-->

### Not null constraints 

What happens when you have a not null constraint on a table is it will re-write the entire table. Under the cover Postgres is really just an append only log. So when you update or delete data it's really just writing new data. This means when you add a column with a new value it has to write a new record. If you do this requiring columns to not be null then you're re-writing your entire table. 

Where this becomes problematic for larger applications is it will hold a lock preventing you from writing new data during this time. 

### A better way

Of course you may want to not allow nulls and you may want to set a default value, the problem simply comes when you try to do this all at once. The safest approach at least in terms of uptime for your table -> data -> application is to break apart these steps. 

1. Start by simply adding the column with allowing nulls but setting a default value
2. Run a background job that will go and retroactively update the new column to your default value
3. Add your not null constraint. 

Yes it's a few extra steps, but I can say from having walked through this with a number of developers and their apps it makes for a much smoother process for making changes to your apps.