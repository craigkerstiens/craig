--- 
layout: post
title: Postgres Dollar Quoting
tags: 
- Postgres, SQL, PostgreSQL
categories: [Postgres, SQL, PostgreSQL]
type: post
published: true
comments: false
---

After my most recent post on [documenting your database](/2013/07/29/documenting-your-postgres-database/) I had a colleague and friend chime in:

{% blockquote @danfarina https://twitter.com/danfarina/status/362007008079126528 %}
@craigkerstiens You may want to mention for another post the generality of dollar quoting: it's not just for CREATE FUNCTION.
{% endblockquote %}

Luckily I was able to convince him to create the post. You can read a bit more on him below, but without further adieu here's a bit on dollar quoting within Postgres:

<!--more-->

Postgres supports two forms of entry of data literals into the system.
One is the familiar single-quote:

    => SELECT 'hello';
     ?column?
    ----------
     hello
    (1 row)

This format is problematic when one might be using single quotes in
the textual string.  

Postgres also supports another way to enter data
literals, most often seen in `CREATE FUNCTION`, but can be profitably
used anywhere.  This is called "dollar quoting," and it looks like
this:

    => SELECT $$hello's the name of the game$$;
               ?column?
    ------------------------------
     hello's the name of the game
    (1 row)

If one needs nested dollar quoting, one can specify a string, much
like the 'heredoc' feature seen in some programming languages:


    => SELECT $goodbye$hello's the name of the $$ game$goodbye$;
                ?column?
    ---------------------------------
     hello's the name of the $$ game
    (1 row)

This can appear anywhere where single quotes would otherwise be,
simplifying tasks like using contractions in database object comments,
for example:

    => CREATE TABLE described(a int);
    => COMMENT ON TABLE described IS $$I'm describing this,
    including newlines and an apostrophe in the contraction "I'm."$$;

Or, alternatively, entry of literals for types that may include
apostrophes in their serialization, such as 'text' or 'json':

    => CREATE TABLE json(data json);
    => INSERT INTO json(data) VALUES
           ($${"quotation": "'there is no time like the present'"}$$);

### Security

Even though dollar quotes can be used to reduce the pain of many
quoting problems, don't be tempted to use them to avoid SQL injection:
an adversary that knows one is using dollar quoting can still mount
exactly the same kind of attacks as if one were using single quotes.

There is also no need, because any place a data literal can appear can
also be used with parameter binding (e.g. `$1`, `$2`, `$3`...), which one's
Postgres driver should support.  Nevertheless, for data or scripts one
is working with by hand, dollar quoting can make things much easier to
read.

### About the Author

Daniel Farina is a long time colleague and friend, having worked together at 5 different companies. He's part of the [Heroku Postgres](https://twitter.com/danfarina/status/362007008079126528) team as the resident tuple groomer, and the creator of [WAL-E](https://github.com/wal-e/wal-e). 

*As is always the case if you have articles you'd like to see created or if you're interested in doing a guest post  please feel free to drop me a line [craig.kerstiens at gmail.com](mailto:craig.kerstiens@gmail.com). And if you have articles you feel are helpful to others in the Postgres world drop me a note as well for including them in [Postgres Weekly](http://www.postgresweekly.com).*