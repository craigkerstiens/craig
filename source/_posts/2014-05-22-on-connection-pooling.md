--- 
layout: post
title: Postgres and Connection Pooling
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

Connection pooling is quickly becoming one of the more frequent questions I hear. So here's a primer on it. If there's enough demand I'll follow up a bit further with some detail on specific Postgres connection poolers and setting them up.

### The basics

For those unfamiliar, a connection pool is a group of database connections sitting around that are waiting to be handed out and used. This means when a request comes in a connection is already there whether in your framework or some other pooling process, and then given to your application for that specific request or transaction.  In contrast, without any connection pooling your application will have to reach out to your database to establish a connection. While in the most basic sense you may thinking connecting to a database is quick, often theres [some overhead here](/2013/03/07/Fixing-django-db-connections/). An example is SSL negotiation that may have to occur which means you're looking at not 1-2 ms but often closer to 30-50. 

<!--more-->

### The options

There's really two major options when it comes to connection pooling:

* Framework pooling
* Standalone pooler
* *Persistent connections* 

#### Framework pooling

Today many modern application frameworks have at least some basic level of connection pooling. This means as your application server starts up it will create a pool of connections to use. It's worth noting that while most modern frameworks have pooling, not all do, and further it may not be enabled by default. 

If you're using the Sequel ORM for Ruby or SQLAlchemy for Python you're well covered here. Further [Rails](https://devcenter.heroku.com/articles/concurrency-and-database-connections) is in pretty good shape also, though you may want to configure the pool size. For Django it's a bit of a mixed story. For some time [Django](/2013/03/07/Fixing-django-db-connections/) did not have pooling at all. As of Django 1.6 you now have persistent connections by default and the ability to enable a pool. 

#### Persistent connections

Persistent connections don't offer all of the benefits of pooling, but can often work well enough. Persistent connections is the act of maintaining a connection to your database once it's connected. In the case where you have overhead of 30-50 ms each time you connect this can be quite helpful. At the same time you're limited to the number of things that can be interacting with your databases as you're limited to 1 connection per entry point to your webserver. 

#### Standalone pooling

Postgres can be a bit of a sore spot when it comes to handling a ton of connections. For Postgres each connection you have to your database assumes some overhead of memory. Casual observations have seen it be between 5 and 10 MB assuming some basic query workload. And even if you have the memory overhead on your Postgres instance there becomes a point where management of connections becomes a limiting factor, we've seen this somewhere in the hundreds. While framework level connection poolers can give some better performance and lengthen the time before you have to deal with something more complex if you're successful that time may come. 

*A rule of thumb I'd use is if you have over 100 connections you want to look at something more robust*

In this case that something more robust is a standalone pooler specifically for Postgres. A standalone pooler can be much more configurable overall letting you specify how it works for Postgres sessions, transactions, or statements. Further these are very specifically designed to work with Postgres handling a very large pool of connections without adding too much overhead. In contrast to the 5MB-ish standard connection to Postgres PG Bouncer has a 2kb per connection. 

So once you're at the point of needing one there's really two options. 

1. [PG Bouncer](http://pgfoundry.org/projects/pgbouncer)
2. [PG Pool](http://www.pgpool.net/mediawiki/index.php/Main_Page)


### PG Bouncer

My short and sweet recomendation is towards PG Bouncer. Contrary to how it's named PG Pool is a multi purpose tool that does a lot of things (pooling, load balancing, replication, more). PG Bouncer takes the philosophy of doing one thing and doing it extremely well. I tend to favor these types of tools, which is the same reason I lean towards [WAL-E](https://github.com/wal-e/wal-e) to help with Postgres replication.

### Need more?

Need more guidance with setting up and running PGBouncer? Give this [guide](http://datachomp.com/archives/getting-started-with-pgbouncer/) a look or try the [pgbouncer buildpack](https://github.com/gregburek/heroku-buildpack-pgbouncer) if running on Heroku. If you're still interested in a deeper guide let me know [@craigkerstiens](http://www.twitter.com/craigkerstiens) and I'll work on getting it into the queue. 

Finally, make sure to sign-up below to get updates on Postgres content and first access to training.

<!-- Begin MailChimp Signup Form -->
<link href="//cdn-images.mailchimp.com/embedcode/classic-081711.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#mc_embed_signup{background:#fff; clear:left; font:14px Helvetica,Arial,sans-serif; }
	/* Add your own MailChimp form style overrides in your site stylesheet or in this style block.
	   We recommend moving this block and the preceding CSS link to the HEAD of your HTML file. */
</style>
<div id="mc_embed_signup">
<form action="http://craigkerstiens.us5.list-manage.com/subscribe/post?u=0bb2ad96ec10236507971efdc&amp;id=dacc2c6d9a" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate>
<div class="indicates-required"><span class="asterisk">*</span> indicates required</div>
<div class="mc-field-group">
	<label for="mce-EMAIL">Email Address  <span class="asterisk">*</span>
</label>
	<input type="email" value="" name="EMAIL" class="required email" id="mce-EMAIL">
</div>
	<div id="mce-responses" class="clear">
		<div class="response" id="mce-error-response" style="display:none"></div>
		<div class="response" id="mce-success-response" style="display:none"></div>
	</div>    <!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups-->
    <div style="position: absolute; left: -5000px;"><input type="text" name="b_0bb2ad96ec10236507971efdc_dacc2c6d9a" tabindex="-1" value=""></div>
    <div class="clear"><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div>
</form>
</div>
<script type="text/javascript">
var fnames = new Array();var ftypes = new Array();fnames[0]='EMAIL';ftypes[0]='email';
try {
    var jqueryLoaded=jQuery;
    jqueryLoaded=true;
} catch(err) {
    var jqueryLoaded=false;
}
var head= document.getElementsByTagName('head')[0];
if (!jqueryLoaded) {
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = '//ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js';
    head.appendChild(script);
    if (script.readyState && script.onload!==null){
        script.onreadystatechange= function () {
              if (this.readyState == 'complete') mce_preload_check();
        }    
    }
}

var err_style = '';
try{
    err_style = mc_custom_error_style;
} catch(e){
    err_style = '#mc_embed_signup input.mce_inline_error{border-color:#6B0505;} #mc_embed_signup div.mce_inline_error{margin: 0 0 1em 0; padding: 5px 10px; background-color:#6B0505; font-weight: bold; z-index: 1; color:#fff;}';
}
var head= document.getElementsByTagName('head')[0];
var style= document.createElement('style');
style.type= 'text/css';
if (style.styleSheet) {
  style.styleSheet.cssText = err_style;
} else {
  style.appendChild(document.createTextNode(err_style));
}
head.appendChild(style);
setTimeout('mce_preload_check();', 250);

var mce_preload_checks = 0;
function mce_preload_check(){
    if (mce_preload_checks>40) return;
    mce_preload_checks++;
    try {
        var jqueryLoaded=jQuery;
    } catch(err) {
        setTimeout('mce_preload_check();', 250);
        return;
    }
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'http://downloads.mailchimp.com/js/jquery.form-n-validate.js';
    head.appendChild(script);
    try {
        var validatorLoaded=jQuery("#fake-form").validate({});
    } catch(err) {
        setTimeout('mce_preload_check();', 250);
        return;
    }
    mce_init_form();
}
function mce_init_form(){
    jQuery(document).ready( function($) {
      var options = { errorClass: 'mce_inline_error', errorElement: 'div', onkeyup: function(){}, onfocusout:function(){}, onblur:function(){}  };
      var mce_validator = $("#mc-embedded-subscribe-form").validate(options);
      $("#mc-embedded-subscribe-form").unbind('submit');//remove the validator so we can get into beforeSubmit on the ajaxform, which then calls the validator
      options = { url: 'http://craigkerstiens.us5.list-manage.com/subscribe/post-json?u=0bb2ad96ec10236507971efdc&id=dacc2c6d9a&c=?', type: 'GET', dataType: 'json', contentType: "application/json; charset=utf-8",
                    beforeSubmit: function(){
                        $('#mce_tmp_error_msg').remove();
                        $('.datefield','#mc_embed_signup').each(
                            function(){
                                var txt = 'filled';
                                var fields = new Array();
                                var i = 0;
                                $(':text', this).each(
                                    function(){
                                        fields[i] = this;
                                        i++;
                                    });
                                $(':hidden', this).each(
                                    function(){
                                        var bday = false;
                                        if (fields.length == 2){
                                            bday = true;
                                            fields[2] = {'value':1970};//trick birthdays into having years
                                        }
                                    	if ( fields[0].value=='MM' && fields[1].value=='DD' && (fields[2].value=='YYYY' || (bday && fields[2].value==1970) ) ){
                                    		this.value = '';
									    } else if ( fields[0].value=='' && fields[1].value=='' && (fields[2].value=='' || (bday && fields[2].value==1970) ) ){
                                    		this.value = '';
									    } else {
									        if (/\[day\]/.test(fields[0].name)){
    	                                        this.value = fields[1].value+'/'+fields[0].value+'/'+fields[2].value;									        
									        } else {
    	                                        this.value = fields[0].value+'/'+fields[1].value+'/'+fields[2].value;
	                                        }
	                                    }
                                    });
                            });
                        $('.phonefield-us','#mc_embed_signup').each(
                            function(){
                                var fields = new Array();
                                var i = 0;
                                $(':text', this).each(
                                    function(){
                                        fields[i] = this;
                                        i++;
                                    });
                                $(':hidden', this).each(
                                    function(){
                                        if ( fields[0].value.length != 3 || fields[1].value.length!=3 || fields[2].value.length!=4 ){
                                    		this.value = '';
									    } else {
									        this.value = 'filled';
	                                    }
                                    });
                            });
                        return mce_validator.form();
                    }, 
                    success: mce_success_cb
                };
      $('#mc-embedded-subscribe-form').ajaxForm(options);
      
      
    });
}
function mce_success_cb(resp){
    $('#mce-success-response').hide();
    $('#mce-error-response').hide();
    if (resp.result=="success"){
        $('#mce-'+resp.result+'-response').show();
        $('#mce-'+resp.result+'-response').html(resp.msg);
        $('#mc-embedded-subscribe-form').each(function(){
            this.reset();
    	});
    } else {
        var index = -1;
        var msg;
        try {
            var parts = resp.msg.split(' - ',2);
            if (parts[1]==undefined){
                msg = resp.msg;
            } else {
                i = parseInt(parts[0]);
                if (i.toString() == parts[0]){
                    index = parts[0];
                    msg = parts[1];
                } else {
                    index = -1;
                    msg = resp.msg;
                }
            }
        } catch(e){
            index = -1;
            msg = resp.msg;
        }
        try{
            if (index== -1){
                $('#mce-'+resp.result+'-response').show();
                $('#mce-'+resp.result+'-response').html(msg);            
            } else {
                err_id = 'mce_tmp_error_msg';
                html = '<div id="'+err_id+'" style="'+err_style+'"> '+msg+'</div>';
                
                var input_id = '#mc_embed_signup';
                var f = $(input_id);
                if (ftypes[index]=='address'){
                    input_id = '#mce-'+fnames[index]+'-addr1';
                    f = $(input_id).parent().parent().get(0);
                } else if (ftypes[index]=='date'){
                    input_id = '#mce-'+fnames[index]+'-month';
                    f = $(input_id).parent().parent().get(0);
                } else {
                    input_id = '#mce-'+fnames[index];
                    f = $().parent(input_id).get(0);
                }
                if (f){
                    $(f).append(html);
                    $(input_id).focus();
                } else {
                    $('#mce-'+resp.result+'-response').show();
                    $('#mce-'+resp.result+'-response').html(msg);
                }
            }
        } catch(e){
            $('#mce-'+resp.result+'-response').show();
            $('#mce-'+resp.result+'-response').html(msg);
        }
    }
}

</script>
<!--End mc_embed_signup-->
