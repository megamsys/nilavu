$(document).ready(function() {

	$.fn.editable.defaults.mode = 'popup';

	// bootstrap3 editable
	$('#changeappname').editable({
		type : 'text',
		title : 'Subdomain (eg: www, idapp..)',
		success : function(response, newValue) {
			$('#appname').val(newValue);
		}
	});

	// bootstrap3 editable
	$('#changeservicename').editable({
		type : 'text',
		title : 'Subdomain (eg: www, dwdb',
		success : function(response, newValue) {
			$('#servicename').val(newValue);
		}
	});

});

unicorn = {
	// === Peity charts === //
	sparkline : function() {
		$(".sparkline_line_good span").sparkline("html", {
			type : "line",
			fillColor : "#B1FFA9",
			lineColor : "#459D1C",
			width : "50",
			height : "24"
		});
		$(".sparkline_line_bad span").sparkline("html", {
			type : "line",
			fillColor : "#FFC4C7",
			lineColor : "#BA1E20",
			width : "50",
			height : "24"
		});
		$(".sparkline_line_neutral span").sparkline("html", {
			type : "line",
			fillColor : "#CCCCCC",
			lineColor : "#757575",
			width : "50",
			height : "24"
		});

		$(".sparkline_bar_good span").sparkline('html', {
			type : "bar",
			barColor : "#83bd67",
			barWidth : "5",
			height : "24"
		});
		$(".sparkline_bar_bad span").sparkline('html', {
			type : "bar",
			barColor : "#55acd2",
			barWidth : "5",
			height : "24"
		});
		$(".sparkline_bar_neutral span").sparkline('html', {
			type : "bar",
			barColor : "#757575",
			barWidth : "5",
			height : "24"
		});
	},

	// === Tooltip for flot charts === //
	flot_tooltip : function(x, y, contents) {

		$('<div id="tooltip">' + contents + '</div>').css({
			top : y + 5,
			left : x + 5
		}).appendTo("body").fadeIn(200);
	}
}