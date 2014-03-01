--- 
layout: post
title: Converting Bookmarklet to Chrome Extension
wordpress_id: 189
comments: true
wordpress_url: http://www.craigekerstiens.com/?p=189
date: 2011-02-02 00:34:49 -08:00
---
Google's documentation is pretty good when it comes to how to create an extension that opens a full page and has large functionality. But if you're more interested in transforming an existing bookmarklet into an extension there's not great quality on it. The steps themselves are really quite simple. The big key that's not heavily documented is creating a background html that creates an event listener. After the jump is a full sample that would then call your javascript to activate the bookmarklet:

<!--more-->manifest.json
<pre>{
 "background_page": "background.html",
 "browser_action": {
 "default_icon": "48x48.png",
 "default_title": ""
 },
 "content_scripts": [ {
 "js": [ "bm.js" ],
 "matches": [ "http://*/*" ]
 } ],
 "description": ",
 "icons": {
 "128": "64x64.png",
 "48": "48x48.png"
 },
 "name": "",
 "permissions": [ "tabs" ],
 "update_url": "http://clients2.google.com/service/update2/crx",
 "version": "1.0.1"
}</pre>
background.html
<pre><script type="text/javascript"><!--mce:0--></script>&lt;script&gt;
chrome.browserAction.onClicked.addListener(function(tab) {
chrome.tabs.sendRequest(tab.id, {fun: "callBM"})
});
&lt;/script&gt;</pre>
bm.js
<pre>function loadBookmarklet()
{
 if(typeof(MyBookmark) != 'undefined' &amp;&amp; typeof(MyBookmark.BM) != 'undefined')
 {
 MyBookmark.BM.OnButtonPressed();
 }
 else if(document.getElementById){
 var x=document.getElementsByTagName('head').item(0);
 var o=document.createElement('script');
if(typeof(o)!='object') o=document.standardCreateElement('script');
 o.setAttribute('src','http://www.mysite.com/bookmarklet.js');
 o.setAttribute('type','text/javascript');
 x.appendChild(o);
 }
} 

chrome.extension.onRequest.addListener(
 function(request, sender) {
 console.log(sender.tab ?
 "from a content script:" + sender.tab.url :
 "from the extension");
 if (request.fun == "callBM")  loadBookmarklet();
 });</pre>
