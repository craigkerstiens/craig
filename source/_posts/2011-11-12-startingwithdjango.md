--- 
layout: post
title: Getting Started with Django
categories: [Python, Django]
type: post
published: false
comments: true
---

For those completely new to web development, Django is a web framework that makes it easier to build web applications with Python. For those that have some knowledge of other web frameworks and Django you may be able to fly through much of the following. Django is a slight modification on the [MVC](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) construct which views itself as a [MVT](https://docs.djangoproject.com/en/dev/faq/general/#django-appears-to-be-a-mvc-framework-but-you-call-the-controller-the-view-and-the-view-the-template-how-come-you-don-t-use-the-standard-names) Model, View, Template. Django views a website as a project and within it smaller apps are contained. 

Earlier we installed Django into your virtual environment. If your environment is loaded we can get started with a Django project. First lets create the project:

``` bash
django-admin.py startproject myproject
```

This should have created a directory for your project called myproject. Within the myproject folder you'll find some core files to every Django project.

``` bash
$ ls
myproject	venv
$ ls myproject
manage.py	myproject
$ ls myproject/myproject
__init__.py	settings.py	urls.py
```

Let's examine a little of each of the files and what they're used for:

`manage.py` - A management utility for interacting with your Django project. In addition to the default commands available which you see by running `python manage.py`, you can create custom commands (we'll get into that much later).
`settings.py` - This is the settings file for your application. Here you'll put various configuration and load things such as your database connection.
`urls.py` - This is the place to setup how your urls will work. You'll define a path for the url and then which code is to be executed when you visit that url.
