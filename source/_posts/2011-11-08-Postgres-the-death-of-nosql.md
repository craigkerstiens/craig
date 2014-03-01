--- 
layout: post
title: Postgres... The death of NoSQL
tags: 
- Business
category: SQL
type: post
published: false
comments: true
---

NoSQL has long been a trend that many have talked about. While there's a place for various key-value stores and tools such as memcache and redis, this will address most specifically how NoSQL is attempting to replace a traditional database. I've long been a fan of postgres and in general traditional relational databases. In a broad sense traditional databases offer multiple things.

## RDMS

### Data guarantees

The current major SQL databases (SQL Server, Postgres, MySQL, Oracle) offer guarantees around your data that doesn't always exist with other systems. At a very high level this means when they say they have the data there's not a chance they'll loose it. When using something as a primary datastore this is always my first requirement. Data is a valuable commodity so keeping it around is obviously important. There are cases where exceptions exist (reporting applications are common here). The specific thing I always look for is that a system upholds the ACID properties. For a quick breakdown of these:

* *A* is for atomic. In short it means no transaction can be partially completed, its all or nothing.
* *C* is for consistent. This means you go from one consistent state to another. Meaning things like cascades and constraints are upheld and can't be ignored for a period of time.
* *I* is for isolation. This means transactions don't get to interfere with each other. 
* *D* is for durability. This means once the transactions there its not going anywhere.

These basic principles make me feel pretty content with my data being safe. This doesn't include things like backups and replication, but rather is a baseline for me feeling safe with a system. 

*Here's a hint, many NoSQL solutions don't enforce these which is where they get speed from*

### Consistent means for accessing data (SQL)

Many people complain about SQL and while its not a perfect language it is a common standard for accessing data. There are idioms that exist in Oracle that do not in Postgres and ones that exist in MySQL that do not in SQL Server, but on the whole ANSI-SQL is a common standard. This means if you learn one in large part you learn another (from an application developers perspective). This means you have a broader people to pull from when you consider moving from one to another, and that skills are more portable. While Mongo may be growing, its in no way guaranteed to be around in 5 years, nor is CouchDB. In fact there have been many NoSQL databases that have come and gone:

* Tokyo Cabinent
* 

## Postgres

So there's some shared things that make databases great, but in particular Postgres aims to be the single database capable of ushering in a death to NoSQL. While each item could easily be its own blog post hopefully the following calls out they key values and allows people to dive in deeper.

### HStore

I strongly debated saving the best for last, but really just couldn't wait. If there's a single feature in Postgres that will kill NoSQL its HStore. HStore is a data-type that allows you to store a dictionary within postgres. 

### Custom datatypes



### PostGIS

Location is all the buzz these days and more and more applications have some tough of location involved in them. 