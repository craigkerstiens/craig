--- 
layout: post
title: Apps to Services
tags: 
- Python, Django, SOA, Services
categories: [Engineering, Python, Django]
type: post
published: true
comments: false
---

*Update the talk for this is now viewable on YouTube [here](http://www.youtube.com/watch?v=ztGpK-v2Oow)*

When I first came across Django I was an immediate fan. It featured:

* Good documentation
* Steady but stable progress
* Community around apps which encouraged *DRY*

I've been a user off and on depending on my needs for nearly four years since discovering it, and throughout that time all of the above have remained true. However, as I've worked on and encountered more complex applications there's one thing that has time and again broke down for me, which is the Django apps model. It hasn't broken down due to Django only though, I've seen it break down in Ruby (Rails), Java, .Net, take you're pick of language or framework. 

The breakdown of this model is due to several things:

<!-- more -->

* Successful applications grow which mean more complex applications and more developers
* More complex applications often mean larger code bases
  * Deprecating code is good, but not always easy in large code bases
  * More code means more testing, but slower releases

At Heroku one way we often describe the platform to others is *"A distributed Unix in the cloud."* There may be many reasons for this, but one of which is that we love the Unix approach and philosophy of *Small sharp tools*. Sticking to that, many of our internal pieces are small individual apps that talk across defined contracts or APIs. 

Back to Django's app structure... Many people build apps and re-use them and often share them with the world. This is truly great for re-usability, which means you can focus on building key features. However, this does not enable your application to be more maintainable in the future nor does it enable scalability. Yes, you can absolutely scale a monolithic application, but it doesn't mean you should. This doesn't mean the app structure is entirely broken, it just means that it is a partial step to where you should be. The real solution is to build more of these pieces of your greater application as services. 

A Django app is defined as *A web application that does something. I.e. Weblog, Poll, Ticket system*. Within Django an app contains:

* Models
* Views
* URLs

I couldn't find a great definition of a Service that was succinct and also said something of value (If you have one please pass along as I'd love to have a definition from a source other than myself). For the sake setting something in place I'm defining a service as *Method of communication over the web with a provider using a defined contract*. By this definition a service contains:

* Provider
* Endpoint
* Contract

Let me clarify this a bit further...

Tangible example/parable:

Django Apps::

* Ticket 
* FAQ

Company Teams::

* Support
* Community Evangelist

You start with two apps, that maybe share a little code. Moreover they at least exist in a central code base. Then you deploy something and the Ticket app can no longer create FAQ, due to a change in one or the other. There's no finger to point, but more importantly, you don't know how to contact to resolve. Neither team wants to deploy, so you test more. Before every deploy you run tests... and validate a build... and deployment slows... well maybe not with two teams. But as you get to 5 teams it does, and more so with 15, and more so with 30 teams. Then you hire a build master and release master, who really wants that?

So within Django maybe you go from apps all in the same codebase to releasing private versions of apps...

Your requirements.txt for a main site looks like:

``` python requirements.txt

FAQ==0.2

```

You have 3 apps which depend on it, support, marketing, billing. You bump a version `FAQ==0.3` but then all three or no teams have to upgrade the version to the new APIs. However if your interface was:

``` python

data = {
‘question’: “my question”,
‘source’: 123
}
requests.POST(os.environ[‘FAQ_API’] + ‘/v1/create’, data=data)

```

You could also have: 

``` python

data = {
‘question’: “my question”,
‘source’: 123,
‘related’: [456, 789]
}
requests.POST(os.environ[‘FAQ_API’] + ‘/v2/create’, data=data)

```

Then you can easily support both, deprecate v1, and track its usage easily. This doesn't guarantee, but it does enable *re-usability*, *scalability*, *maintainability*. And of course continues to let you build features instead of maintaining software.

In the next post I'll go into a bit more detail of how a real example looks with apps in both forms, using a set of Django Apps and using a set of Services built on Django Apps.

*Slides from a corresponding talk at DjangoCong are [here](http://bit.ly/djangocong)*

