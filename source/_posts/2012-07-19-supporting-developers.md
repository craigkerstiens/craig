--- 
layout: post
title: Rapid API Prototyping with Heroku Postgres Dataclips
tags: 
- Development, Developer, Postgres, API, Prototype, Mobile, iOS
categories: [Development, Developer, Postgres, API, Prototype, Mobile, iOS]
type: post
published: true
comments: false
---

For small and large applications there often comes a time where you're busy creating an API. The API creation process usually takes the form of something like: Design your API, Implement your API, Test and Evaluate, Rinse and Repeat. Often you're unable to tell how you truly feel about your API without fully implementing it, causing this cycle to take longer than it should. Heroku Postgres has Dataclips, which (among other things) can be used for quickly prototyping APIs. Lets take a look at how this would work:

## Given a schema

![schema](http://f.cl.ly/items/0n0k1h3q1I1W1T373q0D/1.%20psql.png)

We the screen shot of the schema above we can see we have a few tables. These tables are the complete works of Shakespeare. Lets take a couple of hypothetical endpoints we've decided on that we'd like to expose for users and test as an API.

* The number of works per year
* Drone factory (this is a fun one courtesy of ....). Its essentially who has the longest paragraphs on average in his works.

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

Click `Create Clip` and you'll be redirected to your new dataclip. This unique URL will always return the results of that query and if you want to shift it to a real time API that re-runs the query you can flip the `now` switch. For my simple example above my url for this dataclip is now [https://postgres.heroku.com/dataclips/ljfeywbwtxbcabardaxvcstjyodi](https://postgres.heroku.com/dataclips/ljfeywbwtxbcabardaxvcstjyodi).

## Using the dataclip as a prototype API

There's many different use cases for dataclips, but of course for our sake we care about prototyping an API instead of sharing the data. To do this you can simply append the format you want to the url above and test as if it were an API:

* JSON - [https://postgres.heroku.com/dataclips/ljfeywbwtxbcabardaxvcstjyodi.json](https://postgres.heroku.com/dataclips/ljfeywbwtxbcabardaxvcstjyodi.json)
* CSV - [https://postgres.heroku.com/dataclips/ljfeywbwtxbcabardaxvcstjyodi.csv](https://postgres.heroku.com/dataclips/ljfeywbwtxbcabardaxvcstjyodi.csv)
* YAML - [https://postgres.heroku.com/dataclips/ljfeywbwtxbcabardaxvcstjyodi.yaml](https://postgres.heroku.com/dataclips/ljfeywbwtxbcabardaxvcstjyodi.yaml)

Essentially anything you can bake down to a query (much like you would in your App's API layer) you can expose in this form to quickly test. For a more complicated example you can check out the [Drone factor query](https://postgres.heroku.com/dataclips/tzvzbnnijzezyvzwjeoibwdpfjqb).