--- 
layout: post
title: Why Postgres
tags: 
- Development, Postgres, Database
categories: [Engineering, Development, Postgres, Database]
type: post
published: true
comments: false
---
	
*This post is a list of many of the reasons to use Postgres, much this content as well as how to use these features will later be curated within [PostgresGuide.com](http://www.postgresguide.com). If you need to get started check out [Postgres.app](http://postgresapp.com) for Mac, or get a Cloud instance at [Heroku Postgres](https://postgres.heroku.com/?utm_source=referral&utm_medium=content&utm_campaign=craigkerstiens) for free*

*UPDATE: A [part 2](/2012/05/07/why-postgres-part-2/) has been posted on [Why Use Postgres](/2012/05/07/why-postgres-part-2/)*

Very often recently I find myself explaining why Postgres is so great. In an effort to save myself a bit of time in repeating this, I though it best to consolidate why Postgres is so great and dispel some of the historical arguments against it. 

## Replication

For some time the biggest argument for MySQL over Postgres was the lack of a good replication story for Postgres. With the release of [8.4 Postgres's](http://www.postgresql.org/docs/8.4/static/high-availability.html) story around replication quickly became much better. 

*While replication is indeed very important, are users actually setting up replication each time with MySQL or is it to only have the option later?*

## Window functions

This is a feature those familiar with Oracle greatly missed in Postgres. In fact even SQL Server had some form of them, though it was with T-SQL, which adds a bit more complexity to the feature. This is a feature that once you have you can't live without; the other options that existed before were slower and much more complicated. With the release of [8.4](http://www.postgresql.org/docs/9.1/static/tutorial-window.html) window functions were added to bring Postgres on par with Oracle in this area. For more info on using them check the Postgres docs above or [PostgresGuide.com](http://postgresguide.com/tips/window.html).

## Flexible Datatypes

Creating a custom column is simpler in Postgres than any other database I've used by far. Excluding custom datatypes, even Postgres's out of the box datatypes make Postgres stand out far ahead of other databases. In particular the ability to create a column as an [Array](http://www.postgresql.org/docs/9.1/static/arrays.html) of some datatype. Want to store a game of tic-tac-toe in a database, or an array of 1 user's phone numbers? It simply becomes a single column that can contain multiple phone numbers for a user. 
<!-- more -->

## Functions

Need to do some logic outside of standard SQL? Postgres likely has a function already available to do it for you. What about the time you wanted to take all rows returned by a query and combine them into a function? Give [array_agg a look](http://www.postgresql.org/docs/9.1/static/functions-aggregate.html). Need to split a string and grab a part of it or some other string action, there's a [function for that](http://www.postgresql.org/docs/9.1/static/functions-string.html). 

## Custom Languages

Want to use another language inside your database? Postgres probably supports it:

* [Python in Postgres](http://www.postgresql.org/docs/9.1/static/plpython.html)
* [Ruby in Postgres](https://github.com/knu/postgresql-plruby)
* [R in Postgres](http://www.joeconway.com/plr/)
* [V8 in Postgres](http://code.google.com/p/plv8js/wiki/PLV8)

## Extensions

Need to go beyond standard Postgres? There's a good chance that someone else has, and that there's already an extension for it. Extensions take Postgres further with things such as Geospatial support, JSON data types, Key Value Stores, and connecting to external data sources (Oracle, MySQL, Redis). I could easily have a full post on extensions available alone, fortunately someone else has already created an awesome one - [PostgreSQL Most Useful Extensions](http://blog.railsware.com/2012/04/23/postgresql-most-useful-extensions/).

## NoSQL gives flexibility

I don't want to get too NoSQL versus SQL debate.... no matter which side you fall on you can get both in Postgres. With hstore and [PLV8](http://code.google.com/p/plv8js/wiki/PLV8) you'll get the flexibility in your data that you would with Mongo along with all of the above features. [Will Leinweber](http://www.twitter.com/leinweber) has a talk that he's given at several conferences recently that highlights [Schemaless SQL](http://ssql-railsconf.herokuapp.com/).

## Custom Functions

Didn't find the function you wanted in the above? Try creating it yourself:

```bash
    CREATE FUNCTION awesomeness(varchar) RETURNS boolean
	    AS 'CASE WHEN $1 == \'postgres\' THEN TRUE ELSE FALSE END;'
	    LANGUAGE SQL
	    IMMUTABLE
	    RETURNS NULL ON NULL INPUT;
```

## Common Table Expressions

Often times when exploring data or creating a new view you'll want to load data into a temporary table. When exploring data you only need this for a temporary time. Why actually go through the effort of putting it into a temporary table, especially if you only need it for a single query. [Common Table Expressions](http://www.postgresql.org/docs/8.4/static/queries-with.html) let you accomplish just that. 

## Development Pace

For some period of time MySQL and Postgres were both moving at fast paces. In recent years though Postgres has rapidly picked up its pace of how much gets packed into a single release. Just take a look at the  [Major Releases](http://en.wikipedia.org/wiki/PostgreSQL#Major_releases). 

## Conclusion

Hopefully you're convinced on why Postgres is a great tool. Next take a visit to [PostgresGuide](http://www.postgresguide.com) if you need some direction on where to start or how to use many of the above features.

<!-- Perfect Audience - why postgres - DO NOT MODIFY -->
<img src="http://ads.perfectaudience.com/seg?add=691030&t=2" width="1" height="1" border="0" />
<!-- End of Audience Pixel -->


<!-- Begin MailChimp Signup Form -->
<link href="//cdn-images.mailchimp.com/embedcode/classic-081711.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#mc_embed_signup{background:#fff; clear:left; font:14px Helvetica,Arial,sans-serif; }
	/* Add your own MailChimp form style overrides in your site stylesheet or in this style block.
	   We recommend moving this block and the preceding CSS link to the HEAD of your HTML file. */
</style>
<div id="mc_embed_signup">
<form action="http://craigkerstiens.us5.list-manage.com/subscribe/post?u=0bb2ad96ec10236507971efdc&amp;id=dacc2c6d9a" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate>
	<h2>Sign up to get weekly advice and content on Postgres</h2>
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