// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require twitter/bootstrap
//= require_tree .
//= require spin
!function(d, s, id) {
	var js, fjs = d.getElementsByTagName(s)[0];
	if (!d.getElementById(id)) {
		js = d.createElement(s);
		js.id = id;
		js.src = "//platform.twitter.com/widgets.js";
		fjs.parentNode.insertBefore(js, fjs);
	}
}(document, "script", "twitter-wjs");


$(document).ready(function() {

	// For the purposes of illustration, write to the console on each ajax
	// event to show the events being fired and the sequence in which they are
	// fired
	// "ajax:beforeSend" and "ajax:complete" event hooks are provided by Rails
	// 3's jquery-ujs driver.
	$("*[data-spinner]").live('ajax:beforeSend', function(e) {
		console.log('before');
		$($(this).data('spinner')).show();
		e.stopPropagation(); // Don't show spinner of parent elements.
	}).live('ajax:complete', function() {
		$($(this).data('spinner')).hide();
	}).live("ajax:success", function(xhr, data, status) {
		jQuery(jQuery(this).data('spinner')).hide();
		console.log('success');
	}).live("ajax:complete", function(xhr, status) {
		console.log('complete');
	}).live("ajax:error", function(xhr, status, error) {
		console.log('error ' + error + "status="+ status);
	});
});

function removeForm(current_row) {
	console.log('removeForm ' + current_row);
	$(current_row).remove();
}

function insertContent(loc,content) {
	console.log('insertContent (' +loc +') =>'+ content);
	$(loc).append(content);	
}
jQuery(document)
.ready(
		function() {
			$("#example").hide();

			jQuery("#my-collapse-nav > li > a[data-target]").parent(
					'li').hover(
					function() {
						jQuery(
								jQuery(this).children('a[data-target]')
										.data('target')).collapse(
								'show');
					},
					function() {
						jQuery(
								jQuery(this).children('a[data-target]')
										.data('target')).collapse(
								'hide');
					});
			(function($) {

				// Attach this new method to jQuery
				$.fn
						.extend({

							// This is where you write your plugin's
							// name
							spkToolbar : function(options) {

								// Set the default values, use comma to
								// separate the settings, example:
								var defaults = {
									isDraggable : false,
									droppableDiv : undefined
								};

								var options = $.extend(defaults,
										options);
								// Iterate over the current set of
								// matched elements
								return this
										.each(function() {
											var o = options;
											$(this).addClass('toolbar');
											if (o.isDraggable)
												$('.toolbar')
														.draggable();
											$(this).addClass(
													'spkToolbar');

											var obj = $(this);

											// Get all LI in the UL
											var items = $(obj);
											// jAlert('This is a custom
											// alert box ITEM');

											items.draggable({
												appendTo : "body",
												helper : 'clone'
											});
											if (o.droppableDiv != undefined) {
												$(o.droppableDiv)
														.droppable(
																{
																	drop : function(
																			event,
																			ui) {
																		// clone
																		// the
																		// original
																		// draggable,
																		// not
																		// the
																		// ui.helper
																		jQuery(
																				'#new-dropcontainer ul')
																				.append(
																						ui.draggable
																								.clone(true));
																		// some
																		// extra
																		// code
																		// for
																		// proper
																		// widget
																		// creation
																	}
																});
											}
										});
							}
						});
			})(jQuery);

			jQuery('#toolbar').spkToolbar({
				droppableDiv : '#new-dropcontainer'
			});

			$("#salesforce").click(function() {
				alert("Click event");
				// var drop = $('#example');
				// alert(drop);
				// $('.hello').appendTo('.goodbye');
				$('.sforce').appendTo('.rit');
				$("#example").show();

			});
		});
