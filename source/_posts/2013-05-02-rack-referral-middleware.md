--- 
layout: post
title: Rack Referral Tracking and Reporting
tags: 
- Ruby
categories: [Ruby]
type: post
published: false
comments: true
---

Recently I had a need to track typical referral data inside my application database. While in 90% of cases google analytics, kissmetrics, or mixpanel would work in some cases I want to simply track referral and campaign data inside my core databse. If you have one single monolithic application this is pretty simple to do, however if you've got multiple properties and still want to track across all of them I found it a bit more effort. To ease this I've created a gem