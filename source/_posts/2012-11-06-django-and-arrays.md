--- 
layout: post
title:  Using Postgres Arrays in Django
tags: 
- Development, Postgres, Array
categories: [Development, Django, Postgres, Array]
type: post
published: true
comments: false
---

A few weeks back I did a brief [feature highlight on Postgres arrays](/2012/08/20/arrays-in-postgres/). Since that time I've found myself using them with increasing regularity on small side projects. Much of this time I'm using Django and of course not opting to write raw SQL to be able to use arrays. Django actually makes it quite simple to work with Arrays in Postgres with a package by [Andrey Antukh](http://www.niwi.be/about.html). Lets get started by installing two libraries:

    pip install djorm-ext-pgarray
    pip install djorm-ext-expressions

The first library is for support for the array field type, the second allows us to more easily mix bits of SQL within the Django ORM.

<!-- more -->

Now within our `models.py` we'll want import the library then we'll have an entirely new field type available to us:

    from djorm_pgarray.fields import ArrayField
    from djorm_expressions.models import ExpressionManager

    class Post(models.Model):
        subject = models.CharField(max_length=255)
        content = models.TextField()
        tags = ArrayField(dbtype="varchar(255)")

Now we can begin using this. For example to create a simple blog post:

    Post(subject='foo', content='bar', tags=['hello','world'])
    post.save()

In this example we're able to tag blog posts as one normally might, without requiring an extra model to join against. Taking advantage of the SQL Expressions library by Andrey as well we can query a blog post contains a certain tag:

    qs = Posts.objects.where(
        SqlExpression("tags", "@>", ['postgres', 'django'])
    )

Now to show some contrast lets take a look at how you would do the same thing without using the Array field:

    class Tag(models.Model):
        name = models.CharField(max_length=255) 

    class Post(models.Model):
        subject = models.CharField(max_length=255)
        content = models.TextField()
        tags = models.ManyToManyField(Tag)

Using the many-to-many relationship within Django requires you to save the Post, then add your tag is it requires having a primary key first:

     post = Post(subject='foo', content='bar')
     post.save()
     post.tags.add('hello','world')

This means we have two calls to save it, and similarly querying it is less clean as well:

    posts = Post.objects.filter(tags__name="hello").distinct()

This would gives us all posts that have the tag hello in them. We could also search for multiple ones:

    posts = Post.objects.filter(tags__in=["hello","world"]).distinct()

In the latter case distinct is especially important since it could return a post twice if its tagged with both hello and world. 

In addition to an improvement on performance the gotchas are far less in dealing with a single array datatype and make it a quick but great win in certain cases like above. 