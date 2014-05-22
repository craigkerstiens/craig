--- 
layout: post
title: PostgreSQL 9.4 - What I was hoping for
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

Theres no doubt that the [9.4 release](/2014/02/02/Examining-PostgreSQL-9.4/) of PostgreSQL will have some great improvements. However, for all of the improvements it delivering it had the promise of being perhaps the most impactful release of [Postgres](http://www.amazon.com/dp/B008IGIKY6?tag=mypred-20) yet. Several of the features that would have given it my stamp of best release in at least 5 years are now already not making it and a few others are still on the border. Here's a look at few of the things that were hoped for and not to be at least until another 18 months.

<!--more-->

### Upsert

Upsert, merge, whatever you want to call it, this is been a sore hole for sometime now. Essentially this is insert based on this ID or if that key already exists update other values. This was something being worked on pretty early on in this release, and throughout the process continuing to make progress. Yet as progress was made so were exteneded discussions about syntax, approach, etc. In the end two differing views on how it should be implemented have the patch still sitting there with other thoughts on an implementation but not code ready to commit.

At the same time I'll acknowledge upsert as a hard problem to address. The locking and concurrency issues are non-trivial, but regardless of those having this in there mostly kills the final argument for anyone to chose MySQL.

### Better JSON

JSON is Postgres is super flexible, powerful, and **generally slow**. Postgres does validation and some parsing of JSON, but without something like [PLV8](https://postgres.heroku.com/blog/past/2013/6/5/javascript_in_your_postgres/), or [functional indexes](http://www.craigkerstiens.com/2013/05/29/postgres-indexes-expression-or-functional-indexes/) you may not get great performance. This is because under the covers the JSON is represented as text and as a result many of the more powerful indexes that could lend benefit, such as GIN or GIST, simply don't apply here. 

As a related effort to this [hstore](http://postgresguide.com/sexy/hstore.html), the key/value store, is working on being updated. This new support will add types and nesting making it much more usable overall. However the syntax and matching of how JSON functions isn't guranteed to be part of it. The proposal and actually work is still there and not rejected yet, but looks heavily at risk. Backing a new binary representation of JSON with hstore 2 would deliver so many benefits further building upon the foundation of hstore, JSON, PLV8 that exists today for Postgres.

### apt-get for your extensions

I'm almost not even sure where to start with this one. The notion within a Postgres community is that packaging for distros is super simple and extensions should just be packaged for them. Then there's [PGXN](http://pgxn.org/) the Postgres extension network where you can download and compile and muck with annoying settings to get extensions to build. This proposal would have delivered a built in installer much like NPM or rubygems or PyPi and the ability for someone to simply say install extension from this centralized repository. No, it was setting out to solve the issue of having a single repository but would make it much easier for people to run one. 

For all the awesome-ness that exists in extensions such as [HyperLogLog](http://tapoueh.org/blog/2013/02/25-postgresql-hyperloglog), [foreign data wrappers](http://www.craigkerstiens.com/2012/10/18/connecting_to_redis_from_postgres/), [madlib](http://madlib.net/) theres hundreds of other extensions that could be written and be valuable. They don't even all require C, they could fully exist in JavaScript with PLV8. Yet I'm on the fence encouraging people to write such because if no one uses it then much of the point in the reusability of an extension is lost. Here's hoping that there's a change of opinion in the future that packaging is a solved problem and that creating an ecosystem for others to contribute to the Postgres world without knowing C is a positive thing.

### Logical replication

When I first heard this might have some shot at making it in 9.4 I was shocked. This is something that while some may not take notice of I've felt pain of for many years. Logical replication means in short enabling upgrades across PostgreSQL versions without a dump and restore, but even more so laying the ground work for more complicated architectures like perhaps multi-master. Yes, even with logical replication in theres still plenty of work to do, but having the groundwork laid goes a long way. There are options for it today with third party tools, but the management of these is painful at best. 

### In conclusion 

The positive of this one is that the building blocks are in and its continuing to make progress. Its just that we'll have to wait about 18 months before the release of PostgreSQL 9.5 before its in our hands. 

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