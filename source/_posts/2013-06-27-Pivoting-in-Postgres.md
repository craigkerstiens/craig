--- 
layout: post
title: Pivoting in Postgres
tags: 
- Postgres, SQL, PostgreSQL
categories: [Postgres, SQL, PostgreSQL]
type: post
published: true
comments: false
---

Earlier today on an internal Heroku group alias there was a [dataclip](https://postgres.heroku.com/dataclips) shared. The dataclip listed off some data grouped by a category, there was a reply a few minutes later with a modification to the query that used the `crosstab` function to pivot directly in SQL. There were immediately several reactions on the list that went something like this:

![mindblown](http://f.cl.ly/items/1b0G101r0B2W243b2933/Image%202013.06.27%202%3A06%3A23%20PM.gif)

While a mostly simple function in Postgres (there are a few rough edges), it really is all too handy. So here it is in action. Taking some data that looks like

* row identifier, in this case date
* category grouping, in this case OS
* value

<!--more-->

Given a really basic query that generates some sample data it may look something like this:

    SELECT generate_series AS date,
           b.desc AS TYPE,
           (random() * 10000 + 1)::int AS val
    FROM generate_series((now() - '100 days'::interval)::date, now()::date, '1 day'::interval),
      (SELECT unnest(ARRAY['OSX', 'Windows', 'Linux']) AS DESC) b;

  You get results that look like:

<iframe _tmplitem="2"  src='https://dataclips.heroku.com/cwtnbdhfkpgjhegzktolakjkkpyj/embed?result=1&version=1' width="500px" height="300px"></iframe>

But of course this isn't overly helpful in comparing day to day overall. You can do so on a OS by OS basis, but its annoying enough as is. The easy solution is to simply use a pivot table on your data. Most people at this point would pull it up into Excel or Google Docs, or you can do it directly in Postgres. To do so you'll first enable the extension `tablefunc`:

    CREATE EXTENSION tablefunc

Then you'll use the crosstab function. The function looks something like:

    SELECT * 
    FROM crosstab(
      'SELECT row_name, category_grouping, value FROM foo',
      'SELECT category_names FROM bar')
    AS
      ct_result (category_name text, category1 text, category2 text, etc.)

Lets see it an actual action. Given the same query we used to generate fake data we can actually pivot on it now directly in PostgreSQL:

    SELECT *
    FROM crosstab(
      'SELECT
        a date,
        b.desc AS os,
        (random() * 10000 + 1)::int AS value
         FROM generate_series((now() - ''100 days''::interval)::date, now()::date, ''1 DAY''::interval) a,
              (SELECT unnest(ARRAY[''OSX'', ''Windows'', ''Linux'']) AS DESC) b ORDER BY 1,2
      ','SELECT unnest(ARRAY[''OSX'', ''Windows'', ''Linux''])'
    ) 
    AS ct(date date, OSX int, Windows int, Linux int);

And see some results:

<iframe _tmplitem="1"  src='https://dataclips.heroku.com/dgzcrjoqqjzsxzditlrzpblljgbn/embed?result=1&version=2' width="500px" height="300px"></iframe>

Have fun analyzing your data directly in your DB now. And as always if you have feedback/questions/requests please feel free to drop me a line [craig.kerstiens@gmail.com](mailto:craig.kerstiens@gmail.com)

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