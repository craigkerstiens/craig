--- 
layout: post
title: Getting more out of psql (The PostgreSQL CLI)
tags: 
- Database, Postgres
categories: [Database, Postgres]
type: post
published: true
comments: false
---

*After my last post I had a variety of readers reach out about many different tweaks they'd made to their workflows using with psql. One people [Grégoire Hubert](https://github.com/chanmix51/) had a wondeful extensive list of items. Grégoire has been a freelance in web development and he has worked with Postgresql for some time now in addition to being the author of Pomm. Without further ado heres what he has to say on how he uses psql:*


Get the most of psql
--------------------

Psql, the CLI postgreSQL client, is a powerful tool. Sadly, lot of developers are not aware of the features and instead look for a GUI to provide what they need. Let's fly over what can psql do for you.

<!--more-->

Feel yourself at home
---------------------

One of the most common misconception people have about CLI is «They are a poor user interface». C'mon, the CLI is **the most efficient user interface ever**. There is nothing to disturb you from what you are doing and you are by far fastest without switching to your mouse all the time. Let's see how we can configure psql at our convenience.

First, you'll have managed to choose a nice and fancy [terminal font](http://hivelogic.com/articles/top-10-programming-fonts) like monofur or inconsolata. Do not underestimate the power of the font 

![monofur font in action](http://public.coolkeums.org/github/power_font.png)

The nice line style shown above can be set with `\pset linestyle unicode` and `\pset border 2`. This is just an example of the many environment variables you can play with to get your preferred style of working out of psql. 

For example, I found the character ¤ the most accurate to express nullity (instead of default `NULL`). Let's just `\pset null ¤` and here it is: 

    SELECT * FROM very_interesting_stat;
    ┌──────┬──────┬──────┬──────┬──────┐
    │  a   │  b   │  c   │  d   │  e   │
    ├──────┼──────┼──────┼──────┼──────┤
    │ 9.06 │    ¤ │    ¤ │    ¤ │    ¤ │
    │ 7.30 │ 3.55 │ 7.57 │ 3.31 │    ¤ │
    │ 7.20 │ 5.08 │    ¤ │ 6.58 │ 5.90 │
    ...

Another hugely value to get environment variables is colors in the prompt. Colors in the prompt are important because it makes easier to spot where output starts and ends between two interactions at the console. The [PROMPT1](http://www.postgresql.org/docs/9.2/static/app-psql.html#APP-PSQL-PROMPTING) environment variable will even let you set an indicator to notify you are inside a transaction or not, give this a try for a sweet surprise...

    \set PROMPT1 '%[%033[33;1m%]%x%[%033[0m%]%[%033[1m%]%/%[%033[0m%]%R%# '

I also like to disable the pager by default `\pset pager off` and display the time every issued query takes `\timing`. If you are used to psql, you may notice in the picture above, some content is wrapped. This is `\pset format wrapped` option.

Of course, writing all that on every connection would be a pain, so just write them in a `~/.psqlrc` file, it will be sourced every time psql is launched. 

If you are familiar with `bash` or other recent unix shells, you might also declare aliases in your configuration file. You can do the same with psql. For example if you want to have a query for slow queries such as from this [earlier post](http://craigkerstiens.com/2013/01/10/more-on-postgres-performance/) but not have to remember the query every time you can set it up as:

    \set show_slow_queries 
    'SELECT 
      (total_time / 1000 / 60) as total_minutes, 
      (total_time/calls) as average_time, query 
    FROM pg_stat_statements 
    ORDER BY 1 DESC 
    LIMIT 100;'

Now, just entering `:show_slow_queries` in your psql client will launch this query and give you the results:

        total_time    |     avg_time     |                                                                                                                                                              query
    ------------------+------------------+------------------------------------------------------------
     295.761165833319 | 10.1374053278061 | SELECT id FROM users WHERE email LIKE ?
     219.138564283326 | 80.24530822355305 | SELECT * FROM address WHERE user_id = ? AND current = True

Psql at your fingertips
-----------------------

Now you have got a fancy prompt, here is the real question you ask, what can psql do for me ? and `\?` has all of the answers. It has built-in queries to describe almost all database objects from tables to operators, indexes, triggers etc... with clever auto-completion. Not only completion on tables and columns -- but also on aliases (sweet), **SQL commands** (w00t) and database objects.

Now we can enter some SQL commands. As usual, you need to check in the documentation how the heck to write this damn `ALTER TABLE`. Relax, psql proposes inline documentation. Just enter `\h alter table` (auto complete w00t) and you ll be ok. 

### Interacting with your editor

psql provides two very handy commands: \e and \i. This last command sources a sql file in the client's current session. \e edits the last command using the editor defined in the `EDITOR` shell environment variables (aka vim). This grant you with real editor feature when it comes to writing long queries. What psql does, it saves the buffer in a temporary file and fires up the editor with that file. Once the editor is terminated, psql sources the file. Of course, you can use your editor to save queries in other places where they would be under version control, but the \e has a serious limitation: it spawns only the last query. Even if you sent several queries on the same line. (Note that \r clears psql's last query buffer). 

Note: `\ef my_function` opens stored function source code (With auto completion, I know, it's awesome).

Vim users can here benefit from Vim's server mode. If you launch a vim specifying a server name (let' say "PSQL") somewhere, and set the EDITOR variable as is `export EDITOR="vim --servername PSQL --remote-tab-wait` then psql will open a new tab on the running vim with the last query and run it as soon as you close this tab. Tmux or gnu/screen users will split their screen to have Vim and psql running on the same terminal window.

![Vim, psql and tmux](http://public.coolkeums.org/github/vim_tmux.png)

### Call a friend

Vim power users know it is possible to pipe a buffer (or selection) directly in a program that can be ... psql (Using the `:w !psql` syntax). Even from the shell, you might want to take advantage of the fantastic `\copy` feature that loads formated file in the database (I use it to load apache logs). But always having to specify connection parameters are a hassle. Let's use shell environment instead. Psql is sensitive to the following variables:

 * PGDATABASE
 * PGHOST
 * PGPORT
 * PGUSER
 * PGCLUSTER (debian wrapper).

Set them once for all in you shell environment and call `psql` to connect to the database. In case you want to skip password prompt, you can store your pass in a 600 mode access file named `.pgpass` in your home (do not do that on shared or exposed computers). Although this is nice for development database servers, I do NOT recommend this for production servers since it should not be easy to mess with them. 

Resource for additional information is ... the man page and [Postgres Docs](http://www.postgresql.org/docs/9.2/static/index.html). All [PostgreSQL documentation](http://www.postgresql.org/docs/9.2/static/index.html) is an example of what software reference documentation should be. Enjoy!

<!-- Perfect Audience - why postgres - DO NOT MODIFY -->
<img src="http://ads.perfectaudience.com/seg?add=691030&t=2" width="1" height="1" border="0" />
<!-- End of Audience Pixel -->
