// Start of Nudegespot script
(function(d,n){var s,a,p;s=document.createElement("script");s.type="text/javascript";s.async=true;s.src=(document.location.protocol==="https:"?"https:":"http:")+"//cdn.nudgespot.com"+"/nudgespot.js";a=document.getElementsByTagName("script");p=a[a.length-1];p.parentNode.insertBefore(s,p.nextSibling);window.nudgespot=n;n.init=function(t){function f(n,m){var a=m.split('.');2==a.length&&(n=n[a[0]],m=a[1]);n[m]=function(){n.push([m].concat(Array.prototype.slice.call(arguments,0)))}}n._version=0.1;n._globals=[t];n.people=n.people||[];n.params=n.params||[];m="track register unregister identify set_config people.delete people.create people.update people.create_property people.tag people.remove_Tag".split(" ");for(var i=0;i<m.length;i++)f(n,m[i])}})(document,window.nudgespot||[]);nudgespot.init("425d0d6f052a5ce5ae21931efa800675");
//End of Nudgespot script

//These are helper functions used by the UI
function removeAt(selector_to_remove) {
  $(selector_to_remove).remove();
}

function insertAt(location, content_to_insert) {
  $(location).html(content_to_insert);
}

function repWith(location, content_to_replace) {
  $(location).replaceWith(content_to_replace);
}
//end helper functions.
