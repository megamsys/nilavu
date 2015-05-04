// Start of Tawk.to Script
var $_Tawk_API={},$_Tawk_LoadStart=new Date();
(function(){
var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
s1.async=true;
s1.src='https://embed.tawk.to/552254d2a329e2c841f9fb70/default';
s1.charset='UTF-8';
s1.setAttribute('crossorigin','*');
s0.parentNode.insertBefore(s1,s0);
})();
//End of Tawk.to Script

//These are helper functions used by the UI
function removeAt(selector_to_remove) {
	$(selector_to_remove).remove();
	console.log('removed :' + selector_to_remove);
}

function insertAt(location, content_to_insert) {
	$(location).html(content_to_insert);
	console.log('inserted :' + location + ' =>' + content_to_insert);
}

function repWith(location, content_to_replace) {
	$(location).replaceWith(content_to_replace);
	console.log('replaced :' + location + ' =>' + content_to_replace);
}
//end helper functions.
