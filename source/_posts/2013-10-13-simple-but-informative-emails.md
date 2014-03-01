--- 
layout: post
title: Tooling for Simple but Informative Emails
tags: 
- Hacks, Tips
categories: [Hacks, Tips]
type: post
published: true
comments: false
---

Emails are one of my favorite methods of communicating with users. Its works as a quick test for product validation. It works well at one->some->many-> all. Its still highly effective even as much noise as we receive in our inboxes. Over the years I've tried a lot of email tools from custom built solutions, to newer entrants that help around drip actions ([intercom.io](http://www.intercom.io) and [customer.io](http://www.customer.io)), to more "enterprise" tools such as Marketo. While I have varying opinions on all of those, I still find myself coming back to a simple one off script setup to deliver clear concise emails. 

<!--more-->

### Getting the Data

The first step of any email is deciding what you want to do, but hopefully you know that already. The part that is usually a bit more effort is actually getting the list to send it to and formatting it appropriately. I usually opt for SQL. While the specifics of the query of course always vary it common follows a general structure:

    WITH initial_data AS (
      SELECT 
             email,
             app_name,
             information_about_app 
      FROM
           users,
           apps
      WHERE users.id = apps.user_id
        AND some_filter_to_limit_data
    ),

    candidates_for_email AS ... --- likely to have additional CTEs

    --- Finally I build up the list

    SELECT email,
           array_to_string(array_agg(data_for_email), '
    ') --- an important note is to add a newline or not here depending on how you wish to format it
    FROM candidates_for_email
    GROUP BY email;

The query structure you'll want is first column email, second column whatever data you want to include in your email.

From here I usually create a dataclip of it. This makes it easy to allow my data to change over time. If I'm testing an email for data over the last 7 days I just come back in 7 days and I have new data. It also lets me easily share and iterate on the data. The nice part is there's an easy way to click a button and get the data as a CSV which is what you want for sending. 

Once you download the CSV you'll want to remove the header line as its not needed for the script.

### Sending the Mail

To actually send the email you'll need this script, which is largely credited to [@leinweber](http://www.twitter.com/leinweber):

    require 'mail'
    require 'csv'
    FILE = ARGV[0]

    Mail.defaults do
      delivery_method :smtp, {
        address: 'smtp address',
        port: 587,
        domain: 'gmail.com',
        user_name: 'craig.kerstiens@gmail.com',
        password: ENV.fetch('EMAIL_PASSWORD'),
        authentication: :plain,
        enable_starttls_auto: true
      }
    end


    def send_email(address, app)
      mail = Mail.new do
        to      address
        from    'Craig Kerstiens <craig.kerstiens@gmail.com>'
        subject "Your email subject in here"
        body    generate_body(app)
      end
    end

    def generate_body(app)
      %Q( 
    Hi,

    Your list of apps: 

    #{app}

    Various email content in here...

      )
    end


    CSV.parse(File.read(FILE)).each do |line|
      address = line[0]
      app     = line[1]
      m = send_email(address, app)
      puts m.to_s
      p m.deliver!

      puts
      puts
    end

*You'll want to make sure to export the PW of your email provider with EXPORT EMAIL_PASSWORD=pw_here*

You can easily download this script from off of [Github's Gist](https://gist.github.com/craigkerstiens/6922897). I'd recommend using an email service provider other than Gmail in sending your emails such as [mailgun](http://www.mailgun.com) as they're built to handle sending a large amount of emails. Finally send your emails:

    ruby email.rb nameofyourfile.csv

