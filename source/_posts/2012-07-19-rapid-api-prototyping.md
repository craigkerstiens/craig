--- 
layout: post
title: Rapid API Prototyping with Heroku Postgres Dataclips
tags: 
- Development, Postgres, API, Prototype, Mobile, iOS, Heroku
categories: [Development, Developer, Postgres, API, Prototype, Mobile, iOS, Heroku]
type: post
published: true
comments: false
---

For small and large applications there often comes a time where you're busy creating an API. The API creation process usually takes the form of something like: Design your API, Implement your API, Test and Evaluate, Rinse and Repeat. Historically with implementing the API fully you can't see how you truly feel about the result, causing this cycle to take longer than it should. Heroku Postgres has [Dataclips](https://postgres.heroku.com/blog/past/2012/1/31/simple_data_sharing_with_data_clips/), which (among other things) can be used for quickly prototyping APIs. [Dataclips](https://postgres.heroku.com/dataclips) allows you to easily share data, but more importantly consume it in a form much like you would a restful API. Lets take a look at how this would work:

## Given a schema

![schema](http://f.cl.ly/items/0n0k1h3q1I1W1T373q0D/1.%20psql.png)

We can see from the screen shot of the schema above we can see we have a few tables. These tables are the complete works of Shakespeare thanks to [opensourceshakespeare](http://www.opensourceshakespeare.org/downloads/). Lets take a couple of hypothetical endpoints we've decided on that we'd like to expose for users and test as an API.

* The number of works per year
* Drone factory (this is a fun one courtesy of Richard Morrison - [@mozz100](https://twitter.com/mozz100) essentially who has the longest paragraphs on average in his works.

<!-- more -->

## Create a dataclip

Now we open up our database on Heroku Postgres and go down near the bottom to the dataclips section. Click the plus to create a new dataclip and we can enter our queries.

    SELECT 
      year, 
      count(*) 
    FROM 
      works 
    GROUP BY 
      year 
    ORDER BY 
      year ASC

Click `Create Clip` and you'll be redirected to your new dataclip. This unique URL will always return the results of that query and if you want to shift it to a real time API that re-runs the query you can flip the `now` switch. For my simple example above my url for this dataclip is now [https://dataclips.heroku.com/fcroecrluhwltbjinstfqmwyneex](https://dataclips.heroku.com/fcroecrluhwltbjinstfqmwyneex).

## Using the dataclip as a prototype API

There are many different use cases for dataclips, but of course for our sake we care about prototyping an API instead of sharing the data. To do this you can simply append the format you want to the url above and test as if it were an API:

* JSON - [https://dataclips.heroku.com/fcroecrluhwltbjinstfqmwyneex.json](https://dataclips.heroku.com/fcroecrluhwltbjinstfqmwyneex.json)
* CSV - [https://dataclips.heroku.com/fcroecrluhwltbjinstfqmwyneex.csv](https://dataclips.heroku.com/fcroecrluhwltbjinstfqmwyneex.csv)
* XLS - [https://dataclips.heroku.com/fcroecrluhwltbjinstfqmwyneex.xls](https://dataclips.heroku.com/fcroecrluhwltbjinstfqmwyneex.xls)

Essentially anything you can bake down to a query (much like you would in your App's API layer) you can expose in this form to quickly test. For a more complicated example you can check out the [Drone factor query](https://postgres.heroku.com/dataclips/tzvzbnnijzezyvzwjeoibwdpfjqb).