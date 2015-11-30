--- 
layout: post
title: Upsert lands in PostgreSQL 9.5 – A first look
tags: Postgres
categories: [Postgres]
type: post
published: true
comments: false
---

If you’ve followed anything I’ve [written about Postgres](/2012/04/30/why-postgres/), you know that I’m a fan. At the same time you know that there’s been one feature that so many other databases have, which Postgres lacks and it [causes a huge amount of angst for not being in Postgres](/2014/08/15/my-postgres-wishlist-for-9.5/)… Upsert. Well the day has come, it’s finally committed and will be available [in Postgres 9.5](http://git.postgresql.org/gitweb/?p=postgresql.git;a=commit;h=168d5805e4c08bed7b95d351bf097cff7c07dd65).

Sure we’re still several months away from Postgres 9.5 being released, anywhere from 3-6 months as a best guess. That doesn’t mean we can’t take a first look at this feature. Though before we get into it a few special call outs of thanks to Peter Geoghegan of the [Heroku Postgres](http://www.heroku.com/postgres) team for being the primary author on it, Andres Freund who recently just joined [Citus Data](https://www.citusdata.com) for his heavy contributions, and Heikki Linnakangas as well for his contributions. 

<!-- more -->

And now onto the exploration. Upsert is the common name, but if you’re unfamiliar upsert is essentially create or update – Create this new record, but if a conflict exists update it. Let’s take a practical example. 

Assume you have a web scraper that imports product information into a table. Each product has a UPC code, title, description, and link. There’s a unique constraint on the UPC code. Now, if your web scraper tries to insert a new product, and a product with the same UPC already exists, you’d usually get an error. But you don’t want the query to fail, you’d want to update the existing product instead. Maybe with a new image, maybe a new description, whatever have you, but I don’t want it to blow up… I simply want to capture the new data and save it. 

**So before**: Insert a record… Exception this violates a unique constraint… Let your app figure out what to do. *protip: often applications would try to work around this, but you can run a chance of a race condition and duplicate records if there’s a conflict. TLDR; it’s not a perfect solution.*

**Now**: Insert a record… There’s a unique constraint violation… Okay, let’s just update all the new record’s fields **inside a single transaction**

So enough explanation, here’s how it actually looks in the syntax:

    INSERT INTO products (
        upc, 
        title, 
        description, 
        link) 
    VALUES (
        123456789, 
        ‘Figment #1 of 5’, 
        ‘THE NEXT DISNEY ADVENTURE IS HERE - STARRING ONE OF DISNEY'S MOST POPULAR CHARACTERS! ’, 
        ‘http://www.amazon.com/dp/B00KGJVRNE?tag=mypred-20’
        )
    ON CONFLICT DO UPDATE SET description=excluded.description;

It’s been a long time coming for this, and it makes building applications that need this kind of behavior even easier. While it would have been great for this to be available years ago, kudos to Postgres and its community for taking the approach that is safe for your data. The result we have now both provides the desired behavior of create or update, **and** is performant without the risk of race conditions for your data. 
