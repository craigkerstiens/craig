--- 
layout: post
title: Fixing Database Connections in Django
tags: 
- Django, Python
categories: [Django, Python]
type: post
published: true
comments: false
---

If you're looking to get better performance from your Django apps you can check out [Pro Django](http://www.amazon.com/Pro-Django-Experts-Voice-Development/dp/1430210478?ref=as_li_tf_tl?ie=UTF8&tag=mypred-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0932633439), [PostgreSQL High Performance](http://www.amazon.com/PostgreSQL-High-Performance-Gregory-Smith/dp/184951030X?ref=as_li_tf_tl?ie=UTF8&tag=mypred-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0932633439), or read some my earlier posts on [Postgres Performance](http://www.craigkerstiens.com/2013/01/10/more-on-postgres-performance/). All of these are of course good things to do – you can also start by correcting an incredibly common but also painful performance issue, that until 1.6 is unaddressed in Django.

Django's current default behavior is to establish a connection for each request within a Django application. In many cases any particularly in distributed cloud environments this is a large time sink of your response time. An example application running on [Heroku](http://www.heroku.com) shows a typical connection time of 70ms. A large part of this time is the SSL negotiation that occurs in connecting to your database, *which is a good practice to ensure security of your data*. Regardless, this is a long time in simply establishing a connection. As a point of comparisson its commonly encourage that most queries to your database are under 10ms. 

An example that highlights this in a small lightweight application shows the bulk of a request time being within a connection displayed by [New Relic](http://www.newrelic.com):

![connection time](http://f.cl.ly/items/0X3u0e3Q3G0L19263k2Z/Screenshot_3_6_13_1_12_PM.png)
<!--more-->
![connection time](http://f.cl.ly/items/1h2w450F3n0X1m1c0S38/Screenshot_2_22_13_3_18_PM-2.png)

One option to remedy this is by running a connection pooler on your Database side such as [Pgpool](http://www.pgpool.net/mediawiki/index.php/Main_Page) or [PgBouncer](http://pgfoundry.org/projects/pgbouncer). In fact [Ask the Pony](http://www.askthepony.com/blog/2011/07/getting-django-on-heroku-prancing-8-times-faster/) already highlighted these potential gains. While running an external DB they're essentially testing the benefits of conncetion pooling. This is an obvious gain and can be in a much more lightweight format. 

### Connection Pooling in Django

As Django establishes a connection on each request it has an opportunity to both pool connections and persist connections. There are two major options for pooling, each works quite well with Django and provides some dramatic improvements. While the first request may take the 70ms of connection time, subsequent requests show absolutely no connection time since the connection already exists. This is highlighed by these two comparissons of before and after in actually the times it grabs a connection:

![before](http://f.cl.ly/items/2H0J2x3P2L2K2n0M3i38/Screen_Shot_2013-02-22_at_8.28.21_PM.png)
![after](http://f.cl.ly/items/0T1l1I03433u0c0t3e2o/Screen_Shot_2013-02-22_at_8.28.36_PM.png)

Clearly theres plenty of value to having a persistent connection or a pool within Django itself. As of today theres a few options for that:

### Django-PostgresPool

The first [Django-PostgresPool](https://github.com/kennethreitz/django-postgrespool) is created by [kennethreitz](http://twitter.com/kennethreitz). As in general I'd encourage the use of [dj_database_url]() you can easily begin using his package (once installed) with:

    import dj_database_url

    DATABASE = { 'default': dj_database_url.config() }
    DATABASES['default']['ENGINE'] = 'django_postgrespool'

An important thing to note is if you're using [South](http://south.aeracode.org/) you'll also want to setup the adapter for it:

    SOUTH_DATABASE_ADAPTERS = {
        'default': 'south.db.postgresql_psycopg2'
    }

### djorm-ext-pool

The second option [djorm-ext-pool](https://github.com/niwibe/djorm-ext-pool) is created by [niwibe](http://twitter.com/niwibe). Once you've installed `djorm-ext-pool` you then add it to your `INSTALLED_APPS` within your `settings.py`. From here then you can setup your pool:

    DJORM_POOL_OPTIONS = {
        "pool_size": 20,
        "max_overflow": 0
    } 

### django-db-pool

The third and final option is [django-db-pool](https://github.com/gmcguire/django-db-pool). You can set it up with:


    DATABASES = {'default': dj_database_url.config()}
    DATABASES['default']['ENGINE'] = 'dbpool.db.backends.postgresql_psycopg2'
    DATABASES['default']['OPTIONS'] = {
        'MAX_CONNS': 10
    }

### Gotchas

Each of these does work with recent versions of Django, though in some cases there are gotchas. If using a prodution worthy python web server such as Gunicorn or uwsgi and running with gevent or eventlet some edge cases can present themselves. Regardless of potential gotchas it is worth attempting this and of course providing feedback to maintainers and the community as you find those.

### The future

Django more recently has directly started to address these issues of large costs of establishing a connection. The first major step here is [this patch](https://github.com/django/django/commit/2ee21d) from [Aymeric](http://twitter.com/aymericaugustin). You can find more dicussion around this particular patch [here](https://groups.google.com/forum/#!topic/django-developers/NwY9CHM4xpU/discussion). Essentially with this patch which will hit in Django 1.6 developers then get a persistent connection which will help reduce the time. If you're interested in trying the 1.6 master you can do this by adding it to your requirements.txt as:

    https://github.com/django/django/archive/master.zip

At this point it does not introduce pooling which could allow even more gains, though I'm sure if there's enough need it'll be on a roadmap at some point. Though, as it stands today before 1.6 your best bet is one of the above options.