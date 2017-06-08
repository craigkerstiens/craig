--- 
layout: post
title: Five mistakes beginners make when working with databases 
tags: Postgres
categories: [Postgres]
type: post
published: true
comments: false
syndicate_to_planet: yes
---

When you start out as a developer there's an overwhelming amount of things to grasp. First there's the language itself, then all the quirks of the specific framework you're using,and after that (or maybe before) we'll throw front-end development into the mix, and somewhere along the line you have to decide to store your data somewhere. 

Early on, with so many things to quickly master, the database tends to be an after-though in application design (perhaps because it doesn't make an impact to end user experience). As a result there's a number of bad practices that tend to get picked up when working with databases, here's a rundown of just a few.

<!--more-->

### 1. Storing images

Images don't belong in your database. Just because you can do something, it doesn't mean you should.Images take up a massive amount of space in databases, and slow applications down by unnecessarily eating your database's IO resources. The most common way this mistake occurs is when new developers base64 encode an image and store it in a database large text/blob field.

The better approach is to upload your images directly to a service like Amazon S3, then store the image URL (hosted by Amazon) in your database as a text field. This way, each time you need to load an image, you need to simply output the image URL into a valid `<img>` tag. This will greatly improve website responsiveness, and generally help scale web applications.

### 2. Limit/Offset

Pagination is extremely common in a number of applications.As soon as you start to learn SQL, the most straight-forward way to handle pagination is to `ORDER BY` some column then `LIMIT` the number of results returned, and for each extra page you'll `OFFSET` by so many records. This all seems entirely logical, until you realize at any moderate scale:

1. The load this exerts on your database will be painful.
2. It isn't deterministic, should records change as the user flips between pages.

The unfortunate part is: pagination is quite complex, and there isn't a one-size-fits-all solution. For more information on solving pagination problems, you can check [out numerous options](https://www.citusdata.com/blog/1872-joe-nelson/409-five-ways-paginate-postgres-basic-exotic)

### 3. Integer primary keys

The default for almost all ORMs when creating a primary key is to create a serial field. This is a sequence that auto-increments and then you use that number as your primary key. This seems straight forward as an admin, because you can browse from /users/1 to /users/2, etc. And for most applications this can often be fine. And for most applications, this is fine. But, you'll soon realize as you start to scale that integers primary keys can be exhausted, and are not ideal for large-scale systems. Further you're reliant on that single system generating your keys. If a time comes when you have to scale the pain here will be huge. The better approach is to start [taking advantage of UUIDs](https://til.hashrocket.com/posts/31a5135e19-generate-a-uuid-in-postgresql) from the start. 

*There's also the bonus advantage of not secretly showcasing how many users/listings/whatever the key references directly to users on accident.*

### 4. Default values on new columns

No matter how long you've been at it you won't get the perfect schema on day 1. It's better to think of database schemas as continuously evolving documents. Fortunately, it's easy to add a column to your database, but: it's also easy to do this in a horrific way. By default, if you just add a column it'll generally allow NULL values. This operation is fast, but most applications don't truly want null values in their data, instead they want to set the default value.

If you do add a column with a default value on the table, this will trigger a full re-write of your table. *Note: this is very bad for any sizable table on an application.* Instead, it's far better to allow null values at first so the operation is instant, then set your default, and then, with a background process go and retroactively update the data.

This is more complicated than it should be, but fortunately there are some [handy guides](http://pedro.herokuapp.com/past/2011/7/13/rails_migrations_with_no_downtime/) to help.

### 5. Over normalization

As you start to learn about normalization it feels like the right thing to do. You create a `posts` table, which contains `authors`, and each post belongs in a category. So you create a `categories` table, and then you create a join table `post_categories`. At the real root of it there's not anything fundamentally wrong with normalizing your data, but at a certain point there are diminishing returns. 

In the above case categories could very easily just be an array of varchar fields on a post. Normalization makes plenty of sense, but thinking through it a bit more every time you have a many to many table and wondering if you really need a full table on both sides is worth giving a second thought.

*Edit: It's probably worth saying that under-normalization is also a problem as well. There isn't a one size fits all here. In general there are times where it does make sense to have a completely de-normalized and a completely normalized approach. As [@fuzzychef](https://twitter.com/fuzzychef/status/740248400243785728) described: "use an appropriate amount of normalization i.e. The goldilocks principle"*

### Conclusion

When I asked about this on twitter I got a pretty great responses, but they were all over the map. From the basics of never looking at the queries the ORM is generating, to much more advanced topics such as isolation levels. The one I didn't hit on that does seem to be a worthwhile one for anyone building a real world app is indexing. Knowing how [indexing works](http://www.craigkerstiens.com/2012/10/01/understanding-postgres-performance/), and understanding [what indexes](http://www.craigkerstiens.com/2013/05/30/a-collection-of-indexing-tips/) you need to create is a critical part of getting good database performance. There's a number of posts on indexing that teach the basics, as well as [practical steps](http://www.craigkerstiens.com/2013/01/10/more-on-postgres-performance/) for analyzing performance with Postgres.

In general, I encourage you to treat the database as another tool in your chest as opposed to a necessary evil, but hopefully, the above tips will at least prevent you from making some initial mistakes as you dig in as a beginner.

*Special thanks to [@mdeggies](https://twitter.com/mdeggies) and [@rdegges](https://twitter.com/rdegges) for the initial conversation to spark the post at PyCon.*