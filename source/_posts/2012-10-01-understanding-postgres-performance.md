--- 
layout: post
title: Understanding Postgres Performance
tags: 
- Development, Postgres, Performance, Database
categories: [Development, Postgres, Performance, Database]
type: post
published: true
comments: false
---

*Update theres a more [recent post that expands further on where to start optimizing](/2013/01/10/more-on-postgres-performance/) specific queries, and of course if you want to dig into optimizing your infrastructure [High Performance PostgreSQL is still a great read](http://www.amazon.com/dp/184951030X?tag=mypred-20)*

For many application developers their database is a black box. Data goes in, comes back out and in between there developers hope its a pretty short time span. Without becoming a DBA there's a few pieces of data that most application developers can easily grok which will help them understand if their database is performing adequately. This post will provide some quick tips that allow you to determine whether your database performance is slowing down your app, and if so what you can do about it.

### Understanding your Cache and its Hit Rate

The typical rule for most applications is that only a fraction of its data is regularly accessed. As with many other things data can tend to follow the 80/20 rule with 20% of your data accounting for 80% of the reads and often times its higher than this. Postgres itself actually tracks access patterns of your data and will on its own keep frequently accessed data in cache. Generally you want your database to have a cache hit rate of about 99%. You can find your cache hit rate with:

    SELECT 
	  sum(heap_blks_read) as heap_read,
	  sum(heap_blks_hit)  as heap_hit,
	  sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
	FROM 
	  pg_statio_user_tables;
	
<!-- more -->

We can see in this [dataclip](https://postgres.heroku.com/dataclips/jfrtizxdthixfxkcdesxwesiibly) that the cache rate for [Heroku Postgres](https://postgres.heroku.com?utm_source=referral&utm_medium=content&utm_campaign=craigkerstiens) is 99.99%. If you find yourself with a ratio significantly lower than 99% then you likely want to consider increasing the cache available to your database, you can do this on Heroku Postgres by [performing a fast database changeover](https://devcenter.heroku.com/articles/fast-database-changeovers?utm_source=referral&utm_medium=content&utm_campaign=craigkerstiens) or on something like EC2 by performing a dump/restore to a larger instance size.

### Understanding Index Usage

The other primary piece for improving performance is [indexes](https://devcenter.heroku.com/articles/postgresql-indexes?utm_source=referral&utm_medium=content&utm_campaign=craigkerstiens). Several frameworks will add indexes on your primary keys, though if you're searching on other fields or joining heavily you may need to manually add such indexes. 

Indexes are most valuable across large tables as well. While accessing data from cache is faster than disk, even data within memory can be slow if Postgres must parse through hundreds of thousands of rows to identify if they meet a certain condition. To generate a list of your tables in your database with the largest ones first and the percentage of time which they use an index you can run:

    SELECT 
	  relname, 
	  100 * idx_scan / (seq_scan + idx_scan) percent_of_times_index_used, 
	  n_live_tup rows_in_table
	FROM 
	  pg_stat_user_tables
	WHERE 
		seq_scan + idx_scan > 0 
	ORDER BY 
	  n_live_tup DESC;

While there is no perfect answer, if you're not somewhere around 99% on any table over 10,000 rows you may want to consider adding an index. When examining where to add an index you should look at what kind of queries you're running. Generally you'll want to add indexes where you're looking up by some other id or on values that you're commonly filtering on such as created_at fields.

Pro tip: If you're adding an index on a production database use `CREATE INDEX CONCURRENTLY` to have it build your index in the background and not hold a lock on your table. The limitation to creating indexes [concurrently](http://www.postgresql.org/docs/9.1/static/sql-createindex.html#SQL-CREATEINDEX-CONCURRENTLY) is they can typically take 2-3 times longer to create and can't be run within a transaction. Though for any large production site these trade-offs are worth the trade-off in experience to your end users.

### Heroku Dashboard as an Example

Looking at a real world example of the recently launched Heroku dashboard, we can run this query and see our results:

    # SELECT relname, 100 * idx_scan / (seq_scan + idx_scan) percent_of_times_index_used, n_live_tup rows_in_table  FROM pg_stat_user_tables ORDER BY n_live_tup DESC;
	       relname       | percent_of_times_index_used | rows_in_table 
	---------------------+-----------------------------+---------------
	 events              |                           0 |        669917
	 app_infos_user_info |                           0 |        198218
	 app_infos           |                          50 |        175640
	 user_info           |                           3 |         46718
	 rollouts            |                           0 |         34078
	 favorites           |                           0 |          3059
	 schema_migrations   |                           0 |             2
	 authorizations      |                           0 |             0
	 delayed_jobs        |                          23 |             0
	
From this we can wee the events table which has around 700,000 rows has no indexes that have been used. From here you could investigate within my application and see some of the common queries that are used, one example is pulling the events for this blog post which you are reaching. You can see your [execution plan](https://postgresguide.com/performance/explain.html?utm_source=referral&utm_medium=content&utm_campaign=craigkerstiens) by running an [`EXPLAIN ANALYZE`](https://postgresguide.com/performance/explain.html?utm_source=referral&utm_medium=content&utm_campaign=craigkerstiens) which gives you can get a better idea of the performance of a specific query:

    EXPLAIN ANALYZE SELECT * FROM events WHERE app_info_id = 7559;                                                 QUERY PLAN
    -------------------------------------------------------------------
    Seq Scan on events  (cost=0.00..63749.03 rows=38 width=688) (actual time=2.538..660.785 rows=89 loops=1)
      Filter: (app_info_id = 7559)
    Total runtime: 660.885 ms

Given there's a sequential scan across all that data this is an area we can optimize with an index. We can add our index concurrently to prevent locking on that table and then see how performance is:

    CREATE INDEX CONCURRENTLY idx_events_app_info_id ON events(app_info_id);
    EXPLAIN ANALYZE SELECT * FROM events WHERE app_info_id = 7559;

    ----------------------------------------------------------------------
	 Index Scan using idx_events_app_info_id on events  (cost=0.00..23.40 rows=38 width=688) (actual time=0.021..0.115 rows=89 loops=1)
	   Index Cond: (app_info_id = 7559)
	 Total runtime: 0.200 ms

While we can see the obvious improvement in this single query we can examine the results in [New Relic](https://addons.heroku.com/newrelic) and see that we've significantly reduced our time spent in the database with the addition of this and a few other indexes:

![NewRelicGraph](http://f.cl.ly/items/2x3g2h2220162C2M0w0r/Pasted%20Image%2010:1:12%208:55%20AM-2.png)

### Index Cache Hit Rate

Finally to combine the two if you're interested in how many of your indexes are within your cache you can run:

    SELECT 
	  sum(idx_blks_read) as idx_read,
	  sum(idx_blks_hit)  as idx_hit,
	  (sum(idx_blks_hit) - sum(idx_blks_read)) / sum(idx_blks_hit) as ratio
	FROM 
	  pg_statio_user_indexes;

Generally, you should also expect this to be in the 99% similar to your regular cache hit rate.

If you want help with optimizing your DB for performance or getting insights into your data please reach out [craig.kerstiens@gmail.com](mailto:craig.kerstiens@gmail.com).

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
