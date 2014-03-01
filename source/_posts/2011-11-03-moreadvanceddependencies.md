--- 
layout: post
title: More Advanced Dependencies
tags: 
- Business
category: Python
type: post
published: true
comments: true
---

So we walked through setting up your [virtualenv and installing some packages](/2011/11/01/installingpythonpackages/). The basic workflow for installing packages will work 95% of the time, however part of the time you will need a little more. Below are several cases that may require extra effort. Its likely worthwhile to skim these and only reference them when needed as they likely wont be part of your everyday workflow (with the exception of using mirrors).

Most packages you install should be on pip and an actual released version of a package. There are times however when you may need to test out a package that is still being worked on. For these cases there's what developers commonly do and what you should do.

<!--more-->

If you must install a package from git then you might use something similar to the following:

``` bash requirements.txt
    git+https://github.com/kennethreitz/requests.git#egg=requests
```

Even more ideal is specifying the version:
```
    git+https://github.com/kennethreitz/requests.git==0.6.0#egg=requests
```

*The above should never be done when deploying to production, it reduces predictable behavior and requires that github is available for you to deploy. You should never be dependent on more than PyPi and your own system to deploy.*

Instead when you deploy to production you should point to an internal link. This looks something similar to:

```
    --find-links http://path/to/package/
```

The other item thats not currently (though will be soon) a default behavior is mirrors. For those not familiar, a mirror is essentially a copy of a site (in this case [PyPi](http://pypi.python.org/)). At some point in the future the site may be down preventing you from installing packages or deploying code. If this is the case you're able to use a flag to use these mirrors. If you simple add the flag below it will automatically use the mirrors, allowing you to continue:

``` bash
    pip --use-mirrors install Django
```


