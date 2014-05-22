--- 
layout: post
title: Personas, data science, k-means
tags: 
- Technology
categories: [Technology]
type: post
published: true
comments: false
---

<img src="http://cl.ly/image/183R2i1i2946/Untitled.png" style="float:right;margin-left:20px;"> If one of the industry lingo terms in title  didn't make your skin crawl a little then I need to try harder. At the same time you've probably heard someone use one of them in a non-trolling way in the last month. All three of these can often actually mean the same or similar things, it's just people approach them differently from their world perspective. 

Personas don't have to be marketing only speak, and data science doesn't have to be only for stats people. My goal here is to simply set a context for the rest of the meat which talks about how you can simply look at your data and let it surface things you may not have known. <!--more-->

### Personas

I most commonly hear this term from "business people". In fact not too long ago I recall interacting with someone that wanted to define personas for a company. They wanted to give them names, Joe and Mary. Joe is a father of 2, he works between 8 and 5, because he has to pick kids up from school, he's always worked at fortune 100 companies. Mary is single, she's a small business owner, she likes using tools instead of building things herself. If you think this is overly exaggerated on what you might expect that's fair. Lets take a company I'm fond of [Travis CI](http://www.travisci.com), if someone were to do this for them it might look like:

* Enterprise QA developer
* Startup full stack engineer
* Open source contributor

*While this is all fine and good, a name and what they do doesn't help in the substantial way I'd like.* Sure use personas if it helps you think about who you're building the product for, but don't expect customers to say yes I fit into only this bucket by trying to create classifications like this. 

**Let's rephrase this to be super simple, groupings of people, no groupings of something that have a likely outcome based on some various inputs. Perhaps a better term for it is archtype**

### Data science

The application of math or statistics to learn something about your business. It doesn't have to be big data, or NoSQL, simply the application of an algorithm to learn something. Extending it a bit, let's assume it's to do something actionable. This is a bit of a chicken and egg, because you can't look at different data the same way everytime and have a valuable intrepretation. Sometimes it requires using several methods and examining the quality of the results. We can apply a little more clarity and judgement to ease this process though.

### k-means

Alright onto the meat of what I was hoping to dig into here, well actually first a little more of a detour. Tracking key data for your business should be extremely clear. Hopefully you're already doing this, if you're not already tracking [month over month growth](/2014/02/26/Tracking-MoM-growth-in-SQL/) then go implement it today. If you don't know your lifetime value or attrition rate then get on those too. But if you do have that and still are unclear how to move the needle on some goal, maybe that goal is increasing lifetime value then we're at the right place. 

An extremely old algorithm for grouping things together and fairly commonly known in stats communities is [k-means](http://en.wikipedia.org/wiki/K-means_clustering). It will group things together based on their likeness into some set, thats where the k comes from, of groups. It's also known as an unsupervised clustering method, because you simply put the data in, and let it create these groupings for you. But why or how is it useful, you know you want to influence lifetime value so you should just find what makes people increase it and move that, well... we may be able to get there with k-means. 

### Practicality

Most commonly when you search for k-means you'll find some image similar to the one at the top of the post. This image graphically represents the clustering and the center of those clusters. And while visually interesting doesn't actually tell you how to act upon it. A clearer way is actually often by examing the clusters and whats common, this tells you how to actually treat that archtype differently. 

In his book [Data Smart](http://www.amazon.com/dp/B00F0WRXI0?tag=mypred-20) John Foreman actually does a great job of laying this out in a pratical way. I'm particularly partial to his example also because it uses wine as an example. His example generates a variety of groupings, looking at the surrouding meta data its then possible to discover that:

* Grouping 1 likes Pinot
* Grouping 2 likes buying in bulk
* Grouping 3 likes buying small volume
* Grouping 4 likes bubbly

From here you can then start to get some idea of what you'd do with this. Perhaps you'd create a deal each month so that it appeals to all groups, or target them with different deals. Or maybe you'd simply not send an email to them if you didn't have a deal that month. If course you could go more granular down into a recommendation engine to get a personalized recommendation for each customer, but for a lot of smaller apps/sites that's simply not feasible. 

So in this case the output would look less like the image at the top and more like a set of 4 groups, then a CSV of every user and which grouping they fall in. Yes, its a less sexy graph, but a much more applicable CSV or excel output. 

In the end what we've really done is define personas or archtypes based on whats similar between customers vs. arbitrary perceptions we may come in with. 

### Whats next

Up next I'll actually dig in on a real world example here. [Alex](http://www.twitter.com/alexbaldwin) over at [HackDesign](https://hackdesign.org/) was kind enough to give me access to their data to create a more practical example of this. While I'm just now digging in, there should be a tangible example of this to follow.