--- 
layout: post
title: Sphinx Build Pack on Heroku
tags: 
- Business
categories: [Engineering, Heroku, Python]
type: post
published: true
comments: false
---

Heroku's latest Cedar stack supports running anything. Heroku's officially supported languages actually have their buildpacks public via [Heroku's github](http://github.com/heroku/), you can view several of them at:

* [Python Build Pack](https://github.com/heroku/heroku-buildpack-python)
* [Ruby Build Pack](https://github.com/heroku/heroku-buildpack-ruby)
* [Scala Build Pack](https://github.com/heroku/heroku-buildpack-scala)

*There have even been some created as fun weekend hacks such as the [NES Rom Buildpack](http://github.com/hone/heroku-buildpack-jsnes).*

<!-- more -->

Recently at Heroku my teams have started exploring new forms of collaborating and documenting. In particular editing a wiki for communication is contrary to our regular workflow. Much of our day is spent in code and git. To edit a wiki within a web browser and using some markup we're less familiar with is an overhead we were aiming to reduce. As a result we've tried a few things, the first was simply using a github repo to edit markdown. 

Personally I have always been a fan of Sphinx documentation. However, Sphinx has no means to secure a site out of the box. Generating the static site then running it being a Rack app to secure it seemed like a few extra steps that would hinder workflow. As a result I set out to build the Sphinx buildpack which would let you push a Sphinx project to Heroku and automatically run your documentation. The buildpack itself supports two modes, public documentation and a private documentation. To have your documentation secured in private mode you simple need to add your google apps domain as a config var `heroku config:add DOMAIN=mydomain.com`.

*If you need more information about setting up OpenID check out my recent post [Securing your organization with OpenID ](/2012/01/23/securing-your-organization/)*

```bash
    $ sphinx-quickstart 
    $ git init .
    $ git add .
    $ git commit -m initial
    $ heroku create -s cedar -b http://github.com/craigkerstiens/heroku-buildpack-sphinx.git
    $ git push heroku master
    $ heroku open

```

