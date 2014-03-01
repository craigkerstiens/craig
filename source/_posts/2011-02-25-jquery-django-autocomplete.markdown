--- 
layout: post
title: JQuery and Django Autocomplete
tags: 
- Business
status: publish
type: post
categories: [Python, Django, JQuery]
published: true
comments: true
meta: 
  _edit_last: "1"
  _su_rich_snippet_type: none
  _su_keywords: ""
  dsq_thread_id: "248126827"
---
In a couple of various places I've seen light requests of how to put autocomplete in for a Django web application. Here's a really light weight version with a view and autocomplete functionality using:
<ul>
	<li><a href="http://www.djangoproject.com">Django</a></li>
	<li><a href="http://www.jquery.com">JQuery</a></li>
	<li><a href="http://www.jqueryui.com">JQuery UI</a></li>
</ul>
For a view to search within your django model it would look something like:

``` python models.py 
from django.utils import simplejson
def autocompleteModel(request):
    search_qs = ModelName.objects.filter(name__startswith=request.REQUEST['search'])
    results = []
    for r in search_qs:
        results.append(r.name)
    resp = request.REQUEST['callback'] + '(' + simplejson.dumps(result) + ');'
    return HttpResponse(resp, content_type='application/json')
```

For the jQuery autocomplete and call:

