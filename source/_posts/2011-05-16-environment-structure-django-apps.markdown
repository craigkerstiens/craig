--- 
layout: post
title: Environment Structure for Django Apps
tags: 
- Business
status: publish
type: post
published: true
comments: true
categories: [Python, Django]
meta: 
  _edit_last: "1"
  _su_rich_snippet_type: none
  dsq_thread_id: "305364417"
---
I've been writing applications off and on for nearly 4 years now, since before Django 1.0 was even released. I must say the framework could not be better described than by its own tagline "The Web framework for perfectionists with deadlines". Among the things I love about it are:
<ul>
	<li>Amazing documentation, there's not 30 different blog posts with different ways to do things, either read the django project documentation or the app documentation</li>
	<li>They don't consistently break backwards compatibility. While at times they do this, it is not the norm or standard, which isn't the case for some other unnamed frameworks</li>
	<li>DRY, Don't Repeat Yourself. If there's an app that exists people don't have a burning need to recreate the same functionality, resulting in lower number but higher quality pluggable apps.</li>
</ul>
<!--more-->
However, after using the framework for nearly 4 years I'm just now discovering my preferred way of managing environments. I know there's still a bit of back and forth on development environment/IDE, but as far as configuring actual project environment I've become very comfortable with what I've now been using for many months. It also allows for someone else bootstrapping their environment incredible quickly as well. Below is a quick cookbook of how to do this on OSX and Ubuntu.
<h2>OSX with Macports:</h2>

``` bash
$ sudo port install python27
$ sudo port install py27-virtualenv
$ sudo port install postgresql90
```

Now for setting up your project:

``` bash
$ mkdir example
$ cd example
$ virtualenv-2.7 --no-site-packages .
$ source bin/activate
```

<h2>OSX with Brew:</h2>

``` bash
$ sudo brew install python
$ sudo brew install virtualenv
$ sudo brew install postgresql
```

Now for setting up your project:

``` bash
$ mkdir example
$ cd example
$ virtualenv --no-site-packages .
$ source bin/activate
```

<h2>Ubuntu:</h2>
Now for setting up your project:

``` bash
$ sudo aptitude install python
sudo aptitude install virtualenv
sudo aptitude install postgresql
```

Now for setting up your project:

``` bash
$ mkdir example
$ cd example
$ virtualenv --no-site-packages .
$ source bin/activate
```
For those of you not familiar virtualenv is a self-contained python environment. It holds its own copy of python and any libraries you install. Now that you've setup your virtualenv we can go through the process of installing django and setting up your repository. This is the same across all of the above platforms:

Add to a .gitignore file:

``` bash .gitignore 
bin
build
include 
lib
.Python
*.pyc
```

Add to a requirements.txt file:

``` bash requirements.txt
Django==1.3.1
psycopg2==2.4.1
```

Then run: 

``` bash
$ bin/pip install -r requirements.txt 
```

This should fully installed any of your required apps and makes it easy for others to do the same to begin contributing to a larger app. Finally if you like you can create your git repo from this an make your first commit:

    $ git init
    $ git add .
    $ git commit -m 'my first django virtualenv'
