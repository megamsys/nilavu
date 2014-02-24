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

