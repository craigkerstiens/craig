--- 
layout: post
title:  More on Postgres Performance
tags: 
- Development, Postgres, Performance
categories: [Development, Postgres, Performance]
type: post
published: true
comments: false
---

If you missed my previous post on [Understanding Postgres Performance](/2012/10/01/understanding-postgres-performance/) its a great starting point. On this particular post I'm going to dig in to some real life examples of optimizing queries and indexes. 

### It all starts with stats

I wrote about some of the [great new features in Postgres 9.2](https://postgres.heroku.com/blog/past/2012/12/6/postgres_92_now_available/) in the recent announcement on support of Postgres 9.2 on [Heroku](https://www.heroku.com). One of those awesome features, is [pg\_stat\_statements](http://www.postgresql.org/docs/9.2/static/pgstatstatements.html). Its not commonly known how much information Postgres keeps about your database (beyond the data of course), but in reality it keeps a great deal. Ranging from basic stuff like table size to cardinality of joins to distribution of indexes, and with pg\_stat\_statments it keeps a normalized record of when queries are run. 

<!-- more -->

First you'll want to turn on pg\_stat\_statments:

    CREATE extension pg_stat_statements;

What this means it would record both:

    SELECT id 
    FROM users
    WHERE email LIKE 'craig@heroku.com';

and 

    SELECT id 
    FROM users
    WHERE email LIKE 'craig.kerstiens@gmail.com';

To a normalized form which looks like this:

    SELECT id 
    FROM users
    WHERE email LIKE ?;

### Understanding them from afar

While Postgres collects a great deal of this information dissecting it to something useful is sometimes more mystery than it should be. This simple query will show a few very key pieces of information that allow you to begin optimizing:

    SELECT 
      (total_time / 1000 / 60) as total_minutes, 
      (total_time/calls) as average_time, 
      query 
    FROM pg_stat_statements 
    ORDER BY 1 DESC 
    LIMIT 100;

The above query shows three key things:

1. The total time a query has occupied against your system in minutes
2. The average time it takes to run in milliseconds
3. The query itself

Giving an output something like:

        total_time    |     avg_time     |                                                                                                                                                              query
	------------------+------------------+------------------------------------------------------------
	 295.761165833319 | 10.1374053278061 | SELECT id FROM users WHERE email LIKE ?
	 219.138564283326 | 80.24530822355305 | SELECT * FROM address WHERE user_id = ? AND current = True
	(2 rows)

### What to optimize

A general rule of thumb is that most of your very common queries that return 1 or a small set of records should return in ~ 1 ms. In some cases there may be queries that regularly run in 4-5 ms, but in most cases ~ 1 ms or less is an ideal. 

To pick where to begin I usually attempt to strike some balance between total time and long average time. In this case I'd start with the second probably, as on the first one I could likely shave an order of magnitude off, on the second I'm hopeful to shave two order of magnitudes off thus reducing the time spent on that query from a cumulative 220 minutes down to 2 minutes. 

### Optimizing

From here you probably want to first example my other detail on understanding the explain plan. I want to highlight some of this with a more specific case based on the second query above. The above second query on an example data set does contain an index on user\_id and yet there's still high query times. To start to get an idea of why I would run:

    EXPLAIN ANALYZE
    SELECT * 
    FROM address 
    WHERE user_id = 245 
      AND current = True

This would yield results:

                                                                                       QUERY PLAN
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	 Aggregate  (cost=4690.88..4690.88 rows=1 width=0) (actual time=519.288..519.289 rows=1 loops=1)
	   ->  Nested Loop  (cost=0.00..4690.66 rows=433 width=0) (actual time=15.302..519.076 rows=213 loops=1)
	         ->  Index Scan using idx_address_userid on address  (cost=0.00..232.52 rows=23 width=4) (actual time=10.143..62.822 rows=1 loops=8)
	               Index Cond: (user_id = 245)
	               Filter: current
	               Rows Removed by Filter: 14
	 Total runtime: 219.428 ms
	(1 rows)

Hopefully not being too overwhelmed by this due to having read the other detail on [query plans](/2012/10/01/understanding-postgres-performance/) we can see that it is using an index as expected. The difference is its having to fetch 15 different rows from the index then discard the bulk of them. The number of rows discarded is showcased by the line:

    Rows Removed by Filter: 14

*This is just one more of the many improvements in Postgres 9.2 alongside pg\_stat\_statements.*

To further optimize this we would great a conditional OR composite index. A conditional would be where only current = true, where as the composite would index both values. A conditional is commonly more valuable when you have a smaller set of what the values may be, meanwhile the composite is when you have a high variability of values. Creating the conditional index:

    CREATE INDEX CONCURRENTLY idx_address_userid_current ON address(user_id) WHERE current = True;

We can then see the query plan is now even further improved as we'd hope:

    EXPLAIN ANALYZE
    SELECT * 
    FROM address 
    WHERE user_id = 245 
      AND current = True

                                                                                       QUERY PLAN
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     Aggregate  (cost=4690.88..4690.88 rows=1 width=0) (actual time=519.288..519.289 rows=1 loops=1)
         ->  Index Scan using idx_address_userid_current on address  (cost=0.00..232.52 rows=23 width=4) (actual time=10.143..62.822 rows=1 loops=8)
               Index Cond: ((user_id = 245) AND (current = True))
     Total runtime: .728 ms
	(1 rows)
    
*For further reading, give Greg Smith's [Postgres High Performance](http://www.amazon.com/gp/product/184951030X/ref=as_li_qf_sp_asin_tl?ie=UTF8&tag=mypred-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=184951030X) a read*

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