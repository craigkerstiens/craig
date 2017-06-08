--- 
layout: post
title: Syncing from Postgres to Salesforce - Data Mappings
tags: 
categories: 
type: post
published: true
comments: false
syndicate_to_planet: false
---

For the second time now I've had to implement a system that syncs from my system of record into Salesforce.com, the first at Heroku and now at [Citus Data](https://www.citusdata.com). The case here is pretty simple, I have a software-as-a-service, B2B product. It's a homegrown application in these cases in Ruby, but could be Python, .Net, any language of your choosing. The problem is I don't want to have to be rebuilding my own CRM, reporting, etc. on top of all of my internal database. And as soon as you're at some reasonable size (sales guy of 1 or more) you need to be able to provide insights on what's in that system of record database to others.

While my tooling isn't a full fledged product by any means, here's a bit of how I've developed this process a few times over and some of the annoying bits of code to help get you started. In this post I'll walk through some of the basic datatypes, then we'll follow-up with the overall architecture and tweaks you need to make to Salesforce, and finally we'll provide some example code to help you create this setup yourself.<!--more-->

### Leads, Contacts, Accounts oh my

Despite being some of the largest as-a-service vendors in the world, Salesforce is still primarily setup for traditional high touch sales. What this means is some of the data you'll commonly have, or in this case not have, can make it difficult to figure out what maps from your internal system to Salesforce. Within Salesforce there's really 4 key data models you're going to care about. 

### Lead vs. Contact

In every as a service product you'll have some user that creates and account which usually has an email address tied to it. This seems simple enough to load up to Salesforce as there is a clear email field. Within Salesforce there are two key data types which have a default field for this lead and contact, in Salesforce terms a lead is someone [considering doing business with you](https://success.salesforce.com/answers?id=90630000000gvTiAAI), a contact someone who more so is doing business with you. If you have a freemium or timed trial model you might think to start classifying everyone that they're a lead. Then, when they convert to a paying customer you turn them into a contact. 

If you're anything like me, in running your SaaS business, you want a sign-up process that's frictionless. This means give me an email address, password, and you're off and running. Salesforce immediately starts to breakdown a bit in this regard. First you're required for both lead and contact to provide a first and last name. In my case I do ask for name, and do a little bit of work on the code side to get values into both. You'll see later that our process does result in some regular cleanup work needing to happen, but in our case we're optimizing to get them signed up more than capturing every detail perfectly about them from the start.

Leads are even more broken than contacts though. Leads require you to enter a company. While you may be able to just drop a company form field onto your sign-up page you're likely to end up with junk data at least, if not actually driving some sign-ups away. Some of my favorite pieces of junk data I've seen users enter for company name: "pissed off developer", "Acme Inc.", and the all too common "Test Co.". In reality these are often real developers, with real problems, and real budget, they just don't want to share details before they're ready.

So in this case the TLDR; is that leads require:

* First name
* Last name
* Email
* Company name

This results in contacts being a more favorable datatype because it only requires:

* First name
* Last name
* Email

### Accounts vs. Opportunities

We have in some ways a similar but different dichotomy with Accounts and Opportunities as we did Leads and Contacts. Though this one can often map a bit more cleanly than we saw with leads. From a [pretty straight forward definition](https://success.salesforce.com/answers?id=90630000000gnvcAAA):

* Account - A business entity. Contacts work for Accounts.
* Opportunities - Sales events related to an Account and one or more Contacts.

This again can become problematic if you have no notion of Accounts at all in your system of record. Though if you are building a B2B application there is a good chance you may have something that makes sense. If you let uses free-form enter this instead of AT&T they may put "interactive team", but you at least have some logical team that in their mind they roll up to. 

Opportunities is a much harder one in the SaaS world. In traditional marketing you have your standard stages of MQL (Marketing Qualified Lead), progressing to SQL (Sales Qualified Lead), etc. that you expect these potential customers to flow through. In the as-a-service world you may have people look from afar for weeks, then suddenly sign-up and give you a credit card and start paying within minutes. While there is still steps the customer may go through before buying you often have less insight into these. How you decide to structure your opportunities flow is entirely up to you. In my case I tend to opt to still have htem, but they're an exception basis where a salesperson is actively engaged vs. the other 90%+ of fully self-service customers.

Shifting back a little bit on accounts. The key with accounts is that if you have some notion of an team or org within your system of record then it makes sense to have that same structure setup in Salesforce. The most basic of this might be an idea of "Account owner" and "Team members". You may have a person in there just for billing, an admin, and then users. Even if you don't want to recreate the entire structure at least having all the contacts tied to the account is critical. I can't count the number of times I've seen teams setup a "billing@mycompany.com" email, seen people try to interact with that email when in reality they wanted to be talking to "jane@mycompany.com" who logged in yesterday.

### In summary

For the most part Salesforce doesn't quite let you map to what many of you'll want to do in terms of mapping your data from your system of record to Salesforce. Expect to have to contort a bit and likely pump Salesforce with some garbage data. In general you'll want to skip leads and go straight for contacts as contacts don't require the same restrictions. Tying contacts to an account is the right level anyway, and from there up to you on how you'll more manage the opportunities. 

<img src="https://craig-pixeltracker.herokuapp.com/pixel.gif"/>
