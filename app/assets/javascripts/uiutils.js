jQuery(document)
		.ready(
				function() {
					$("#connector_form").hide();

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
						console.log("click event");
						$('#connector_form').appendTo('#right_pane');
						$('#connector_form').show();
						console.log("append complete.");
					});
				});
