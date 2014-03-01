--- 
layout: post
title: Disabling muting while typing in Google hangouts
tags: 
- Hacks, Tips
categories: [Hacks, Tips]
type: post
published: true
comments: false
---

Google hangouts is awesome, its my preferred method for most audio/video calls these days. When running a group call I often dial into a separate phone if I have a better phone available for the group. It also got around the annoyance that when you are typing google automatically mutes you. This for most people is pretty subpar. While dialing in to the hangout can still be nice, you don't have to do so to get rid of the annoying muting while typing. To fix such simply open up your terminal and run:

     defaults write com.google.googletalkplugind exps -string [\"-tm\"]

*This clever hack discovered courtesy of [@timtyrrell](http://www.twitter.com/timtyrrell) passed along to me by [@mattmanning](http://www.twitter.com/mattmanning) and [@blakegentry](http://www.twitter.com/blakegentry)*