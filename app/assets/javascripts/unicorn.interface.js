/**
 * Unicorn Admin Template
 * Diablo9983 -> diablo9983@gmail.com
**/
jQuery(document).ready(function(){
	
	// === jQuery Peity === //
	jQuery.fn.peity.defaults.line = {
		strokeWidth: 1,
		delimeter: ",",
		height: 24,
		max: null,
		min: 0,
		width: 50
	};
	jQuery.fn.peity.defaults.bar = {
		delimeter: ",",
		height: 24,
		max: null,
		min: 0,
		width: 50
	};
	jQuery(".peity_line_good span").peity("line", {
		colour: "#B1FFA9",
		strokeColour: "#459D1C"
	});
	jQuery(".peity_line_bad span").peity("line", {
		colour: "#FFC4C7",
		strokeColour: "#BA1E20"
	});	
	jQuery(".peity_line_neutral span").peity("line", {
		colour: "#CCCCCC",
		strokeColour: "#757575"
	});
	jQuery(".peity_bar_good span").peity("bar", {
		colour: "#459D1C"
	});
	jQuery(".peity_bar_bad span").peity("bar", {
		colour: "#BA1E20"
	});	
	jQuery(".peity_bar_neutral span").peity("bar", {
		colour: "#757575"
	});
	
	// === jQeury Gritter, a growl-like notifications === //
	jQuery.gritter.add({
		title:	'Unread messages',
		text:	'You have 9 unread messages.',
		image: 	'img/demo/envelope.png',
		sticky: false
	});	
	jQuery('#gritter-notify .normal').click(function(){
		jQuery.gritter.add({
			title:	'Normal notification',
			text:	'This is a normal notification',
			sticky: false
		});		
	});
	
	jQuery('#gritter-notify .sticky').click(function(){
		jQuery.gritter.add({
			title:	'Sticky notification',
			text:	'This is a sticky notification',
			sticky: true
		});		
	});
	
	jQuery('#gritter-notify .image').click(function(){
		var imgsrc = jQuery(this).attr('data-image');
		jQuery.gritter.add({
			title:	'Unread messages',
			text:	'You have 9 unread messages.',
			image: imgsrc,
			sticky: false
		});		
	});
});
