--- 
layout: post
title: Installing Python Packages
tags: 
- Business
category: Python
type: post
published: true
comments: true
---

Now that you have you system and project environment all setup you probably want to start developing. But you likely don't want to start writing an entire project fully from scratch, as you dive in you'll quickly realize theres many tools helping you build projects and sites faster. For example making a request to a website there's [Requests](http://docs.python-requests.org/en/latest/index.html), for handling processing images there's [Python Imaging	 Library](http://www.pythonware.com/products/pil/), or for a full framework to help you in building a site there's [Django](http://www.djangoproject.com). With all of these there's one simple and common way to install them. But first a little more on how it all works. 

<!--more-->

All major Python packages are hosted on [PyPi](http://pypi.python.org/) (Pronounced Pi-P or Cheeseshop). When you use a common python installer it will:

1. Search for the package you specify
2. If you specify a version will use it, otherwise will use the latest
3. Will download the source for that package
4. Install it into your Python environment

Now for actually installing... Lets get started with installing the three packages below. At this point you should at least have a fresh Python environment, however you don't have an immediate way to install packages. The defacto Python package installer is [pip](http://pip-installer.org). 

Earlier we setup virtualenv to help isolate our python packages we were working with. First lets go ahead and create a folder for our project then setup a new environment for the project we'll work on:

``` bash
$ mkdir myapp
$ cd myapp
$ virtualenv --no-site-packages venv
``` 

If we list the contents of the directory you'll now see a folder venv. Within this folder you'll find all the parts of the environment that virtualenv just created:

``` bash
$ ls 
venv
$ ls venv
bin	include	lib
```

Now you've got a sandboxed environment that exists but you haven't loaded it. You can now activate and deactivate this any time you like. Once you do this it customizes your path to use the packages you've installed for this environment. To load your environment when in the myapp directory:

``` bash
$ source venv/bin/activate
```

To deactivate this simple:

``` bash
$ deactivate
```


Now that we've got your environment loaded installing your packages should be pretty simple. Ensure that you have your virtualenv loaded and then run:

``` bash
$ pip install requests
$ pip install PIL
$ pip install Django
```

Now that you've installed your packages you want to be able to share this with others to make it easy to get setup. You could provide a list of everything your application needs to run manually, or because its Python you can expect it to make it easy for you. Pip has a wonderful command freeze that will show all of your packages and their versions that are installed. Simply run:

``` bash
$ pip freeze
```

However, this only outputs the information. Along with this pip has a canonical form for listing requirements and installing them from a file. The filename is commonly a requirements.txt. To create this we simply pipe the results of pip freeze to this file. 

``` bash
$ pip freeze > requirements.txt
```

Next we'll talk about a few more advanced items in dependency management, then finally we'll get started on building an application.