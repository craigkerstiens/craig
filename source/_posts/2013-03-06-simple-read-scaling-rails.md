--- 
layout: post
title: Simple database read scaling without sharding in rails
tags: 
- Ruby, Rails, Database
categories: [Ruby, Rails, Database]
type: post
published: false
comments: false
---

In an earlier post I provided a high level [overview of sharding](http://www.craigkerstiens.com/2012/11/30/sharding-your-database/). Sharding while a very solid approach to scaling capacity versus simply only relying on vertical scaling can also be a time intensive one. Additionally in some cases certain sites may only need extra capacity for a short lived period of time. Fortunately theres a nice middle ground alternative for scaling capacity that works well in quite a few cases. It even has a benefit that can potentially in place of sharding.

This method results in scaling your reads to replica databases, you can do this on Heroku by taking advantage of followers. A follower is a read only database on Heroku Postgres that receives asynchronous updates of your data usually only lagging a very few commits behind. This means you can write all of your data to the leader (main) database, and then read from another. 

*While you can arbitrarily do this there's some major benefits to doing it based on the models. This is because Postgres maintains a cache on each instance its running on. Though you may have the same dataset, Postgres maintains frequently accessed or queried data in the cache giving you better performance. For more on this you can read earlier posts on [PostgreSQL Performance](http://www.craigkerstiens.com/2012/11/30/sharding-your-database/).*

### Setting it up with Rails

With a follower database created you can begin adding support for this to your application. The first thing is to add the gem to your Gemfile:

    gem 'ar-octopus', :require => "octopus"

Then of course to install it with `bundle install`. Now we can actually begin to add the code needed to have specific models access the follower. 

    octopus:
    shards:
      shard_sqlite:
      adapter: sqlite3
      database: db/db_one.sqlite3
      pool: 5
      timeout: 5000

      shard_pgsql:
        adapter: postgresql
        username: postgres
        password:
        database: db_two
        encoding: unicode

a

    class Project < ActiveRecord::Base
      octopus_establish_connection(:adapter => "sqlite3", :database => "db_one")
    end