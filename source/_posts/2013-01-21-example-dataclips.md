--- 
layout: post
title:  OMG Dataclips
tags: 
- Dataclips
categories: [Dataclips]
type: post
published: false
comments: false
---

<iframe _tmplitem="1" id="myIFrame" src='https://dataclips.heroku.com/vgyygvzqtezwpmwpcmmjlluamjlk/embed?result=316&version=1' width="500"  height="300" style="border:3px #999;"></iframe>

<script>
var run_click = function ()
{
	var iFrameID = document.getElementById('myIFrame');
	var clickscript = "<script>document.getElementById('embedToggleResults').click();</script\>"
	iFrameID.contentWindow.contents().find('body').append(clickscript);
}

var t = setTimeout(run_click,2000);
run_click();
</script>
