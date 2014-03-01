--- 
layout: post
title: Diving into Postgres JSON operators and functions
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

Just as [PostgreSQL 9.3](https://postgres.heroku.com/blog/past/2013/9/9/postgres_93_now_available/) was coming out I had a need to take advantage of the JSON datatype and some of the [operators and functions](http://www.postgresql.org/docs/9.3/static/functions-json.html) within it. The use case was pretty simple, run a query across a variety of databases, then take the results and store them. We explored doing something more elaborate with the columns/values, but in the end just opted to save the entire result set as JSON then I could use the operators to explore it as desired. 

Here's the general idea in code (using sequel):

    result = r.connection { |c| c.fetch(self.query).all }
    mymodel.results = result.to_json

<!--more-->

As the entire dataset was stored as some compressed JSON I needed to do a bit of manipulation to get it back into a form that was workable. Fortunately all the steps were fairly straightforward. 

First you want to unnest each result from the json array, in my case this looked like:

    SELECT json_array_elements(result)

The above will unnest all of the array elements so I have an individual result as JSON. A real world example would look something similar to:

    SELECT json_array_elements(result) 
    FROM query_results 
    LIMIT 2;
          json_array_elements
-----------------------------------------
 {"column_name":"data_in_here"}
 {"column_name_2":"other_data_in_here"}
(2 rows)

From here based on the query I would want to get some specific value. In this case I'm going to search for the text key column_name_2:
    
    SELECT json_array_elements(result)->'column_name_2' 
    FROM query_results 
    LIMIT 1;

      json_array_elements  
    -----------------------
     "other_data_in_here"
    (1 rows)

*One gotcha I encountered was when I wanted to search for some value or exclude some value... Expecting I could just compare the result of the above in a where statement I was sadly mistaken because the equals operator didn't translate.* My first attempt at fixing this was to cast in this form:

    SELECT json_array_elements(result)->'column_name_2'::text

The sad part is because of the operator the cast doesn't get applied as I'd expect. Instead you'll want to do:

    SELECT (json_array_elements(result)->'column_name_2')::text

Of course theres plenty more you can do with the [JSON operators in the new Postgres 9.3](http://www.postgresql.org/docs/9.3/static/functions-json.html). If you've already got JSON in your application give them a look today. And while slightly worse, if you've got JSON stored in a text field simply cast it with `::json` to begin using the operators.