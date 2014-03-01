--- 
layout: post
title: Hacker News API 
tags: 
- Business
categories: [Javascript, API, Hacker News]
type: post
published: false
comments: true
---

[Hacker News](http://news.ycombinator.com) is a great source for developers, entrepreneurs, startup people, and in general tech enthusiasts. Given who the community is I'm very surprised to find few apps that make it easier to digest the content or to push content to it. [HNSearch](http://www.hnsearch.com/) is a great start to be able to search data and they even have a [list of apps](http://www.hnsearch.com/apps). In particular I was most surprised to find not many apps existed as tools to make it easier to build on top of HN. As a result I've created two things to make such easier...

### JSON wrapper for HNSearch.com

The first problem I encountered is there was no way to access the HNSearch API directly from javascript. Sure you could write all of your code server side, but for many cases this may not be necessary. 

### HN Button

