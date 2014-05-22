--- 
layout: post
title: The best Postgres feature you're not using – CTEs aka WITH clauses
tags: 
- Postgres, PostgreSQL
categories: [Postgres, PostgreSQL]
type: post
published: true
comments: false
---

SQL by default isn't typically friendly to dive into, and especially so if you're reading someone else's already created queries. For some reason most people throw out principles we follow in other languages [such as commenting](http://www.craigkerstiens.com/2013/07/29/documenting-your-postgres-database/) and composability just for SQL. I was recently reminded of a key feature in Postgres that most don't use by [@timonk](http://www.twitter.com/timonk) highlighting it in his AWS Re:Invent Redshift talk. The simple feature actually makes SQL both readable and composable, and even for my own queries capable of coming back to them months later and understanding them, where previously they would not be.

The feature itself is known as CTEs or common table expressions, you may also here it referred to as `WITH` clauses. The general idea is that it allows you to create something somewhat equivilant to a view that only exists during that transaction. You can create multiple of these which then allow for clear building blocks and make it simple to follow what you're doing. 

<!--more-->

Lets take a look at a nice simple one:

    WITH users_tasks AS (
      SELECT 
             users.email,
             array_agg(tasks.name) as task_list,
             projects.title
      FROM
           users,
           tasks,
           project
      WHERE
            users.id = tasks.user_id
            projects.title = tasks.project_id
      GROUP BY
               users.email,
               projects.title
    )

Using this I could now just append some basic other query on to the end that references this CTE `users_tasks`. Something akin to:

    SELECT *
    FROM users_tasks;

But where it becomes more interesting is chaining these together. So while I have all tasks assigned to each user here, perhaps I want to then find which users are responsible for more than 50% of the tasks on a given project, thus being the bottleneck. To oversimplify this we could do it a couple of ways, total up the tasks for each project, and then total up the tasks for each user per project:

    total_tasks_per_project AS (
      SELECT 
             project_id,
             count(*) as task_count
      FROM tasks
      GROUP BY project_id
    ),

    tasks_per_project_per_user AS (
      SELECT 
             user_id,
             project_id,
             count(*) as task_count
      FROM tasks
      GROUP BY user_id, project_id
    ),

Then we would want to combine and find the users that are now over that 50%:

    overloaded_users AS (
      SELECT tasks_per_project_per_user.user_id,

      FROM tasks_per_project_per_user,
           total_tasks_per_project
      WHERE tasks_per_project_per_user.task_count > (total_tasks_per_project / 2)
    )

Now as a final goal I'd want to get a comma separated list of tasks of the overloaded users. So we're simply giong to join against that `overloaded_users` and our initial list of `users_tasks`. Putting it all together it looks somewhat long, but becomes much more readable. And as a bonus I layered in some comments.

    --- Created by Craig Kerstiens 11/18/2013
    --- Query highlights users that have over 50% of tasks on a given project
    --- Gives comma separated list of their tasks and the project


    --- Initial query to grab project title and tasks per user
    WITH users_tasks AS (
      SELECT 
             users.id as user_id,
             users.email,
             array_agg(tasks.name) as task_list,
             projects.title
      FROM
           users,
           tasks,
           project
      WHERE
            users.id = tasks.user_id
            projects.title = tasks.project_id
      GROUP BY
               users.email,
               projects.title
    ),
    
    --- Calculates the total tasks per each project
    total_tasks_per_project AS (
      SELECT 
             project_id,
             count(*) as task_count
      FROM tasks
      GROUP BY project_id
    ),

    --- Calculates the projects per each user
    tasks_per_project_per_user AS (
      SELECT 
             user_id,
             project_id,
             count(*) as task_count
      FROM tasks
      GROUP BY user_id, project_id
    ),

    --- Gets user ids that have over 50% of tasks assigned
    overloaded_users AS (
      SELECT tasks_per_project_per_user.user_id,

      FROM tasks_per_project_per_user,
           total_tasks_per_project
      WHERE tasks_per_project_per_user.task_count > (total_tasks_per_project / 2)
    )

    SELECT 
           email,
           task_list,
           title
    FROM 
         users_tasks,
         overloaded_users
    WHERE
          users_tasks.user_id = overloaded_users.user_id

CTEs won't always be quite as performant as optimizing your SQL to be as concise as possible. In most cases I have seen performance differences smaller than a 2X difference, this tradeoff for readability is a nobrainer as far as I'm concerned. And with time the Postgres optimizer should continue to get better about such performance. 

As for the verbosity, yes I could have done this query in probably 10-15 lines of very concise SQL. Yet, most may not be able to understand it quickly if at all. Readability is huge when it comes to SQL to ensure its doing the right thing. SQL will almost always tell you an answer, it just may not be to the question you think you're asking. Ensuring your queries can be reasoned about is critical to ensuring accuracy and CTEs are one great way of accomplishing that.

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