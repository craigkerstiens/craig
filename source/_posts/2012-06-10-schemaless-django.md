--- 
layout: post
title: Schemaless Postgres in Django
tags: 
- Development, Postgres, Database, Django, Python
categories: [Development, Postgres, Database, Django, Python]
type: post
published: false
comments: false
---

Earlier this week while I was at [DjangoCon EU](http://lanyrd.com/2012/djangocon-europe/) there seemed to be a surprising amount of talk about MongoDB. My problem with this isn't with MongoDB, but in  the assumption that only Mongo can solve what you're looking for. By and far the most common feature is people want schemaless. It gives them flexibility in their data model and lets them iterate quickly. While I still opt for relational models that map cleanly to a relational database, there are cases where developers may want schemaless. I gave a quick lightning talk on this with slides [here](https://speakerdeck.com/u/craigkerstiens/p/django-and-hstore), but it is worth recapping.

The example given by [pydanny](http://www.twitter.com/pydanny) was a product catalog. You may have different items you want to store for a catalog. Lets take an example below:

    django_pony = {'name': 'Django Pony', 'rating': '5'}
    pink_pony = {'name': 'Pink Pony', 'rating': '4', 'color': 'pink'}

In the case of a product catalog it could be understandable you don't want to normalize every possible spec for the product. The argument for Mongo is so commonly that you can easily work with this data model. Admittedly it is quite simple:

    from pymongo import Connection
    connection = Connection()
    django_pony = {'name': 'Django Pony', 'rating': '5'}
    connection.product.insert(django_pony)

The problem is that this assumes other schemaless options don't exist or are inferior. 

## Enter hStore

[hStore](http://www.postgresql.org/docs/8.4/static/hstore.html) is a column type within Postgres. It is a key value store that allows you to store a dictionary, with text values. It alone is not a full document store replacement, but allows for flexibility in your data model where you need it while letting you use relational models elsewhere. Its not exactly new within Postgres either, as its been available since 8.4, however its recently become easier to work with and is supported in some form or another by more frameworks. 

To do the same as above we only need to do a few steps:

<!-- more -->

Within your Postgres 9.1 or higher database:

    create extension hstore;

*If you don't have Postgres already if you're on a Mac quickly grab and install [Postgres.app](http://postgresapp.com).* 

Now for actually using it within your Django application. You first need to install django-hstore to your project:

    pip install django-hstore

Then you can add it to your models:

	from django.db import models
	from django_hstore import hstore

	class Product(models.Model):
	    name = models.CharField(max_length=250)
	    data = hstore.DictionaryField(db_index=True)
	    objects = hstore.Manager()

	    def __unicode__(self):
	        return self.name
	
Once you've sync'ed your database models you can now add your products in a very similar form to above:

    Product.objects.create(name='Django Pony', data={'rating': '5'})
    Product.objects.create(name='Pony', data={'color': 'pink', 'rating': '4'})

At this point you've got your schemaless data into Postgres and can interact with it. However, this is where the benefits of Postgres quickly start to come into play. In addition to the schemaless model you're able to add indexes and filter on keys/values just as you would expect. In fact within Django it maps similarly to how it would within the ORM:

    colored_ponies = Product.objects.filter(data__contains='color')
    print colored_ponies[0].data['color']

    favorite_ponies = Product.objects.filter(data__contains={'rating': '5'})
    print colored_ponies[0]

To add indexes within postgres we could index on the same items that we're filtering above:

    create index on product(((data->'color')::int)) where ((data->'size') is not null);
    create index on product(((data->'rating')::int)) where ((data->'rating') = '5');

If you need a sample project to start with immediately check out this one on [github](https://github.com/craigkerstiens/hstore-demo).

When evaluating any database its important to choose the features you're evaluating it on, then examine further. Mongo may be great because its schemaless, this doesn't mean an RDMS can't be schemaless as well (and do a good job of it). In the long run, schemaless is likely to just become another feature in databases, but more on that later.