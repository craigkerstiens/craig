--- 
layout: post
title: Postgres Pooling with Django
tags: 
- Development, Postgres, Performance, Database, Django, Python
categories: [Development, Postgres, Performance, Database, Django, Python]
type: post
published: false
comments: false
---

A feature thats glaringly missing within Django and common in many other frameworks including many Java frameworks and Rails is connection pooling for your database connection. As most Django users are Postgres users the default answer is to use something like pgPool or pgBouncer. This are tools that you can run that will persist a connection to your Postgres database intended to offer:

* Connection Pooling
* Replication
* Load Balancing

*Its of not that PgBouncer is intended very specifically for pooling while pgPool does much more.*

Each of these in many cases can come with caveats though. If there are issues within your network they may not re-establish the connection properly. They also are not known to handle SSL renegotiation very well. Finally given running one more piece of software to reduce connection times it seems like a lot of overhead to simply reduce the connection time to your database.

## Is connection time a real problem?

Given a well refined app, with a well refined schema with appropriate indexes your view should be doing things pretty quickly. If this is the case without some form of connection pooling and running in a cloud environment (in this case Heroku) your application performance looks like:

If you'll notice that about 50% of our request time was in Postgres. The hard part to see is how much of this is actually doing something. In this case its issuing some very basic queries then rendering a very basic view. 

## The solution

By using something in *the other Python ORM*, SQLAlchemy, we can take advantage of its connection pooling. Large thanks to [Kenneth Reitz](https://twitter.com/kennethreitz) for packaging this up into an easy to install and easy to use format as a Django DB backend. Using django_postgrespool it will take advantage of connection pooling and we can then see the performance after:

