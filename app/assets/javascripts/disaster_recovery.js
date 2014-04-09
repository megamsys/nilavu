// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$('#drbd_from').on('change', function() {
	$('#drbd_next').prop('disabled', false);
});

jQuery(document).ready(function() {
	$("#backup_storage_view").hide();
	$("#dr_selection input:radio").on("ifClicked", function() {
		var drtype = $(this).attr("value");
		if (drtype == "existing_app") {
			$("#backup_storage_view").hide();
			$("#existing_app_dr_view").show();
		}
		if (drtype == "backup_storage") {
			$("#backup_storage_view").show();
			$("#existing_app_dr_view").hide();
		}
	});

});
