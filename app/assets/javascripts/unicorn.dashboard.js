/**
 * Unicorn Admin Template Diablo9983 -> diablo9983@gmail.com
 */

jQuery(document)
		.ready(
				function() {

					jQuery('#dash').each(function() {
						jQuery('body').css('background', '#444444');
					});

					// init editables

					jQuery('#identity_new_account_name').editable({
						send : 'never'
					});

					
					// === Prepare peity charts === //
					unicornpeity();

					// === Prepare the chart data ===/
					var sin = [], cos = [];
					for ( var i = 0; i < 14; i += 0.5) {
						sin.push([ i, Math.sin(i) ]);
						cos.push([ i, Math.cos(i) ]);
					}

					// === Make chart === //
					var plot = jQuery.plot(jQuery(".chart"), [ {
						data : sin,
						label : "sin(x)",
						color : "#BA1E20"
					}, {
						data : cos,
						label : "cos(x)",
						color : "#459D1C"
					} ], {
						series : {
							lines : {
								show : true
							},
							points : {
								show : true
							}
						},
						grid : {
							hoverable : true,
							clickable : true
						},
						yaxis : {
							min : -1.6,
							max : 1.6
						}
					});

					// === Point hover in chart === //
					var previousPoint = null;
					jQuery(".chart")
							.bind(
									"plothover",
									function(event, pos, item) {

										if (item) {
											if (previousPoint != item.dataIndex) {
												previousPoint = item.dataIndex;

												jQuery('#tooltip').fadeOut(
														200,
														function() {
															jQuery(this)
																	.remove();
														});
												var x = item.datapoint[0]
														.toFixed(2), y = item.datapoint[1]
														.toFixed(2);

												unicorn_flot_tooltip(
														item.pageX, item.pageY,
														item.series.label
																+ " of " + x
																+ " = " + y);
											}

										} else {
											jQuery('#tooltip').fadeOut(200,
													function() {
														jQuery(this).remove();
													});
											previousPoint = null;
										}
									});

					// === Calendar === //
					var date = new Date();
					var d = date.getDate();
					var m = date.getMonth();
					var y = date.getFullYear();

					jQuery('.calendar').fullCalendar({
						header : {
							left : 'prev,next',
							center : 'title',
							right : 'month,basicWeek,basicDay'
						},
						editable : true,
						events : [ {
							title : 'All day event',
							start : new Date(y, m, 1)
						}, {
							title : 'Long event',
							start : new Date(y, m, 5),
							end : new Date(y, m, 8)
						}, {
							id : 999,
							title : 'Repeating event',
							start : new Date(y, m, 2, 16, 0),
							end : new Date(y, m, 3, 18, 0),
							allDay : false
						}, {
							id : 999,
							title : 'Repeating event',
							start : new Date(y, m, 9, 16, 0),
							end : new Date(y, m, 10, 18, 0),
							allDay : false
						}, {
							title : 'Lunch',
							start : new Date(y, m, 14, 12, 0),
							end : new Date(y, m, 15, 14, 0),
							allDay : false
						}, {
							title : 'Birthday PARTY',
							start : new Date(y, m, 18),
							end : new Date(y, m, 20),
							allDay : false
						}, {
							title : 'Click for Google',
							start : new Date(y, m, 27),
							end : new Date(y, m, 29),
							url : 'http://www.google.com'
						} ]
					});
				});

function unicornpeity() {
	// === Peity charts === //
	jQuery.fn.peity.defaults.line = {
		strokeWidth : 1,
		delimeter : ",",
		height : 24,
		max : null,
		min : 0,
		width : 50
	};
	jQuery.fn.peity.defaults.bar = {
		delimeter : ",",
		height : 24,
		max : null,
		min : 0,
		width : 50
	};
	jQuery(".peity_line_good span").peity("line", {
		colour : "#B1FFA9",
		strokeColour : "#459D1C"
	});
	jQuery(".peity_line_bad span").peity("line", {
		colour : "#FFC4C7",
		strokeColour : "#BA1E20"
	});
	jQuery(".peity_line_neutral span").peity("line", {
		colour : "#CCCCCC",
		strokeColour : "#757575"
	});
	jQuery(".peity_bar_good span").peity("bar", {
		colour : "#459D1C"
	});
	jQuery(".peity_bar_bad span").peity("bar", {
		colour : "#BA1E20"
	});
	jQuery(".peity_bar_neutral span").peity("bar", {
		colour : "#757575"
	});
}

function unicorn_flot_tooltip(x, y, contents) {
	// === Tooltip for flot charts === //

	jQuery('<div id="tooltip">' + contents + '</div>').css({
		top : y + 5,
		left : x + 5
	}).appendTo("body").fadeIn(200);
}

/* Get the rows which are currently selected */
function fnGetSelected(oTableLocal) {
	return oTableLocal.jQuery('tr.row_selected');
}
