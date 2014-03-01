--- 
layout: post
title: How Heroku Works - Teams and Tools
tags: 
- Business
categories: [Heroku, Engineering, Business]
type: post
published: true
comments: true
---

Heroku is a largely agile company, we work in primarily small teams that talk via api and data contracts. Its also a company comprised primarily of engineers, even product managers often write code. Heroku as a platform drives many of the features not from top down, but from bottom up based on engineers desires or skunkworks projects. There's many valuable insights into how Heroku runs efficiently for engineering.

I'll be diving into many various practices that enable Heroku to put quality engineering above all else, but first let me highlight the team structure and tools that enable this. 

<!--more-->
Heroku is comprised of many small teams internally, each team operates much like an individual entity. The team chooses its own tools and best method for communication, though as a whole some form of Scrum is run throughout teams. Think of the unix philosophy of small sharp tools [as in The Art of Unix Programming](http://www.amazon.com/gp/product/0131429019/ref=as_li_qf_sp_asin_tl?ie=UTF8&tag=mypred-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0131429019) applied to teams and people.

For most teams this involves a weekly planning meeting earlier in the week. In such a meeting teams may conduct a retrospective, opportunities to improve the process the coming week, and of course plan tasks for the coming week. Its <b>very</b> important to note that planning tasks for the week doesn't necessarily involve planning the deadline for them, but rather simply laying out what people are working on (more on this in a future post). Each team will record and track this in a tool of their own choosing. Several use [pivotal tracker](http://www.pivotaltracker.com), one uses [scrumy](http://www.scrumy.com), some use email to distribute and track against personal to do lists. The method for tracking issues is again entirely up to the individual team. A one person team may choose to use a simple to do list, larger teams commonly use [github](http://www.github.com) issues and pull requests. Given the team is the one responsible for their own productivity the team is the one to choose what tools they use.

Meeting loads vary from person to person depending on what is the demands are on their time, though everyone at Heroku participates in some form of standup. Most teams do these daily as quick status stand-ups of what was worked on the day before and whats to be worked on the next day. In addition to the planning meeting and stand-ups, there is often collaborative engineering, and company wide gatherings. 

Collaborative engineering once again varies depending on which engineers are working together. Engineers may get in front of a white board or in front of machines and simple collaborate. For engineers together in the office this is often the most productive way. These practices work the same for remote employees, though slightly modified for the high touch interaction. For remote employees this often works as pair programming via Skype. Skype is indispensable for allowing remote workers to feel far less remote. Skype alongside [typewith.me](http://typewith.me/) and you have an unbelievable easy to collaborate not just with 1 other, but with multiple parties to work through a document on a given topic. For smaller activities of communication asynchronous is key. This ranges from [campfire](http://campfirenow.com/) most commonly during common working hours when someone is likely to be at a machine, to email when the return on a request may take slightly longer. 

Finally there is the all common company wide meeting, which occurs weekly. The structure of this varies from status updates to broader ongoings. Its often the perfect time for engineers to hear about what sales is doing or get updates on teams you don't commonly interact with. Along with common status updates there will be broader company updates. 

Consistently across all teams you'll find these principles which allow us to ensure the quality of engineering as we continue to grow:

* Small teams that talk across defined API's and data contracts
* Teams using the tool that they believe is best for the job
* Frequent asynchronous communication
* Collaboration (including for remote employees)

The key in Heroku running efficiently is primarily allowing each team to run as it chooses. Heroku works because we have talented engineers, the best thing we can do for those engineers is allow them to work productively. Often only they know the best way to accomplish this, so who better to let them accomplish it than themselves. 





