--- 
layout: post
title: Securing your Internal Organization with OpenID
tags: 
- Business
categories: [Startup, Engineering, Business]
type: post
published: true
comments: false
---

I've recently been amazed at the number of companies that are still using a VPN or other means to manage their apps/network. Not just large enterprisey companies, but small agile startups. I fully understand that it works, but 95% of these places are also using another key tool for access inside their company... *Google Apps*. I fully expect companies to use google apps, its more of the former that surprises me most. For a long time OpenID wasn't at a usable point, even today it still isn't without its faults. However, it does make for a much cleaner workflow once in place than having your users login to something with they're used to using elsewhere.

In our personal lives we use email as our keys to the kingdom. In fact I now almost refuse to sign up for any service that doesn't let me use oauth, so why should a work place be much different. So I inquired with a few companies to see if they were fine with securing things like documentation or wiki's being google auth, they indeed were. Yet they still seem to have users keep one more username and password for their VPN to be able to login to access internal docs/tools. 

<!-- more -->
Most tech centric companies grow their own apps for many things they do within a company. Even the heavier adopters of SaaS still end up building a lot of internal systems. So why not secure them with your email domain just as you commonly would if it were a public service?

The problem comes in that OpenId with google has an initial setup overhead, but after that works unbelievably well. 

## The catch

In some cases you currently have to identify your domain as an OpenId provider. This means that @yourname.com is an OpenId provider. This simply means creating a url route for openid in your base site similar to the below:

``` xml http://heroku.com/openid
<?xml version="1.0" encoding="UTF-8"?>
<xrds:XRDS xmlns:xrds="xri://$xrds" xmlns="xri://$xrd*($v*2.0)">
  <XRD>
    <Service priority="0">
      <Type>http://specs.openid.net/auth/2.0/signon</Type>
      <URI>https://www.google.com/a/craigkerstiens.com/o8/ud?be=o8</URI>
    </Service>
  </XRD>
</xrds:XRDS>
```

*This is due to an issue of OpenID discovery which you can read more on at: https://groups.google.com/group/google-federated-login-api/browse_thread/thread/4a7dd2312a47a082/9285cec18a30b9d3?lnk=gst&q=apps+discovery&pli=1#9285cec18a30b9d3. In short, setting up the above can save you a lot of time*


## Setting up in apps

Most web frameworks have libraries that make it easy to secure your apps with openid/oauth. In particular Django and Rails both make this pretty easy. To make this even simpler for you below is code to actually secure an internal app for both Django and Rails. You can do similar with Flask or Sinatra as well. 

### Rails


In case your admin controller isn't already generated:

```
rails g controller admin/users
```

Then anything you want to secure:

```
module Admin
  class UsersController < ApplicationController
    before_filter :admin_required

    def index
      render :text => 'Hello from the admin panel!'
    end
  end
end
```


### Django


Finally sync your database:

```
python yourapp/manage.py syncdb
```

Secure any view with the `login_required` decorator as your typically would with Django.

## Summary

In short with some very basic app setup you can have an internal workflow thats just as good as what you use in your day to day outside the office. 
