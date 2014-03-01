--- 
layout: post
title: Getting Setup with Python
tags: 
- Python
category: Python
type: post
published: true
comments: true
---

This is the first of a multipart series to getting started with Python. Throughout this guide we'll walk you through a full setup. For starters if you're a mac or linux user you already have [Python](http://python.org) on your system. You should be able to confirm you have python my opening up a terminal window and running:
    
``` bash 
$ python --version
Python 2.7.2
```
<!--more-->
As long as you see a Python version 2.5.x-2.7.x you should be fine to continue. From here we're going to work through setting up your Python project environment. For this we're going to use [virtualenv](http://virtualenv.org). For those of you not familiar [virtualenv](http://virtualenv.org) is a self-contained python environment. It holds its own copy of python and any libraries you install. This allows you to work on multiple projects with different versions of libraries.

While we're installing virtualenv we're also going to go ahead and setup PostgreSQL as we'll be using it later. If you're on a mac you'll first need to setup homebrew. Homebrew is used for installing various system packages. If you're on linux, in particular Ubuntu you can skip down to the steps for setting up your environment.

First for Mac users lets setup homebrew which will allow us to install various system packages:

``` bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
```

<h2>OSX with Brew:</h2>

``` bash
$ curl -O http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg | sh setuptools-0.6c11-py2.7.egg
$ easy_install virtualenv
$ brew install postgresql
```

<h2>Ubuntu:</h2>
Now for setting up your project:

``` bash
$ sudo apt-get install virtualenv
$ sudo apt-get install postgresql
```

Now you have Python, virtualenv, and postgresql all installed. We can now focus on setting up the initial start to a project. 


In the next part we can start with installing some Python packages.