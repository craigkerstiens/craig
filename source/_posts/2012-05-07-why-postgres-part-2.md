--- 
layout: post
title: Why PostgreSQL Part 2
tags: 
- Development, Postgres, Database
categories: [Engineering, Development, Postgres, Database]
type: post
published: true
comments: false
---

*This post is a list of many of the reasons to use Postgres, much this content as well as how to use these features will later be curated within [PostgresGuide.com](http://www.postgresguide.com). If you need to get started check out [Postgres.app](http://postgresapp.com) for Mac, or get a Cloud instance at [Heroku Postgres](https://postgres.heroku.com/?utm_source=referral&utm_medium=content&utm_campaign=craigkerstiens) for free*

Last week I did a post on the [many reasons to use Postgres](/2012/04/30/why-postgres/). My goal with the post was two fold:

 * Call out some of the historical arguments against it that don't hold any more
 * Highlight some of the awesome but more unique features that are less commonly found in databases.

Once I published the post it was clear and was immediately pointed out in the comments and on [hacker news](http://news.ycombinator.com/item?id=3910743) that I missed quite a few features that I'd mostly come to take for granted. *Perhaps this is due to so much awesomeness existing within Postgres.* A large thanks to everyone for calling these out. To help consolidate many of these, here's a second list of the many reasons to use PostgreSQL:

## Create Index Concurrently

On most traditional databases when you create an index it holds a lock on the table while it creates the index. This means that the table is more or less useless during that time. When you're starting out this isn't a problem, but as your data grows and you then add indexes later to improve performance it could mean downtime just to add an index. Not surprisingly Postgres has a great means of adding an index without holding that lock. Simply doing [`CREATE INDEX CONCURRENTLY`](http://www.postgresql.org/docs/9.1/static/sql-createindex.html#SQL-CREATEINDEX-CONCURRENTLY) instead of `CREATE INDEX` will create your index without holding the lock.

*Of course with many features there are caveats, in the case of creating your index concurrently it does take somewhere on the order of 2-3 times longer, and cannot be done within a transaction*

## Transactional DDL

If you've ever run a migration had something break mid-way, either due to a constraint or some other means you understand what pain can come of quickly untangling such. Typically migrations on a schema are intended to be run holistically and if they fail you want to fully rollback. Some other databases such as Oracle in recent versions and SQL server do support, this. And of course Postgres supports wrapping your DDL inside a transaction. This means if an error does occur you can simply rollback and have the previous DDL statements rolled back with it, leaving your schema migrations as safe as your data, and your application in a consistent state.

## Foreign Data Wrappers

I talked before about other languages within your database such as Ruby or Python, but what if you wanted to talk to other databases from your database. Postgres's Foreign Data Wrapper allows you to fully wrap external data systems and join on them in a similar fashion to as if they existed locally within the database. Here's a sampling of just a few of the foreign data wrappers that exist:

 * [Oracle](http://pgxn.org/dist/oracle_fdw/)
 * [MySQL](http://pgxn.org/dist/mysql_fdw/)
 * [Redis](http://pgxn.org/dist/redis_fdw/)
 * [Twitter](http://pgxn.org/dist/twitter_fdw/)

In fact you can even use [Multicorn](http://multicorn.org/) to allow you to write other foreign data wrappers in Python. An example of how this can be done, in this case with Database.com/Force.com can be found [here](http://blog.database.com/blog/2011/11/21/a-database-comforce-com-foreign-data-wrapper-for-postgresql/) 
<!-- more -->

## Conditional Constraints and Partial Indexes

In a similar fashion to affecting only part of your data you may care about an index on only a portion of your data. Or you may care about placing a constraint only where a certain condition is true. Take an example case of the white pages. Within the white pages you only have one active address, but you've had multiple ones over recent years. You likely wouldn't care about the past addresses being indexed, but would want everyones current address to be indexed. With [Partial Indexes](http://www.postgresql.org/docs/9.1/static/indexes-partial.html) becomes simple and straight forward:

```bash 
    CREATE INDEX idx_address_current ON address (user_id) WHERE current IS True;
```

## Postgres in the Cloud

Postgres has been chosen by individual shops and been proven to scale by places such as [Instagram](http://media.postgresql.org/sfpug/instagram_sfpug.pdf) and [Disqus](http://ontwik.com/python/disqus-scaling-the-world%E2%80%99s-largest-django-application/). Perhaps even more importantly it's becoming easy to use PostgreSQL due to the many clouds that are running Postgres as a Service, such as: 

 * [Heroku Postgres](http://postgres.heroku.com) 
 * [VMware vFabric](http://www.vmware.com/products/application-platform/vfabric-data-director/features.html)
 * [Enterprise DB](http://www.enterprisedb.com/)
 * [Cloud Postgres](https://www.cloudpostgres.com)

*Full disclosure, I work at [Heroku](http://www.heroku.com), and am also a large fan of their database service*

## Listen/Notify

If you want to use your database as a queue there's some cases where it just won't work, as heavily discussed in a [recent write-up](http://mikehadlow.blogspot.se/2012/04/database-as-queue-anti-pattern.html). However, much of this could be discarded if you included Postgres in this discussion due to Listen/Notify. Postgres will allow you to [LISTEN](http://www.postgresql.org/docs/9.1/static/sql-listen.html) to an event and of course [NOTIFY](http://www.postgresql.org/docs/9.1/static/sql-notify.html) for when the event has occurred. A great example of this in action is [Ryan Smith's](http://www.twitter.com/ryandotsmith) [Queue Classic](https://github.com/ryandotsmith/queue_classic).

## Fast column addition/removal

Want to add a column or remove one. With millions of records this modification in some databases could take seconds or even minutes, in cases I've even heard horror stories of adding a column taking hours. With Postgres this is a near immediate action. The only time you pay a higher price is when you choose to write default data to a new column.

## Table Inheritance

Want inheritance in your database just like you have in with models inside your application code? Not a problem for Postgres. You can have one table easily inherit for another, leaving a cleaner data model within your database while still giving all the flexibility you'd like on your data model. The Postgres docs on [DDL Inheritance](http://www.postgresql.org/docs/9.1/static/ddl-inherit.html) do a great job of documenting how to use this and giving a very simple but clear use case.

## Per transaction synchronous replication

The default mode for Postgres streaming replication is asynchronous. This works well when you want to maintain performance, but also care about your data. There are cases where you want your replication to be [synchronous](http://www.postgresql.org/docs/current/static/warm-standby.html#SYNCHRONOUS-REPLICATION) though. Furthermore, for some cases asynchronous may work well enough where as other data you may care more about the data and want synchronous replication, within the same database. For example, if you care about user sign-ups and purchases, but ratings of products and comments is less important Postgres provides the ability to treat them as such. With Postgres you can have per transaction synchronous replication, this means you could have strong data guarantee on your user and purchase transactions, and less guarantees on others. This means you only pay the extra performance cost where you really care about versus an all or nothing approach you have with other databases.

## Conclusion

Hopefully you're convinced on why Postgres is a great tool, if not take a look back at my [previous post](/2012/04/30/why-postgres/). 

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