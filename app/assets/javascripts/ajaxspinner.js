jQuery(document)
		.ready(
				function() {
					// "ajax:beforeSend" and "ajax:complete" event hooks are
					// provided by Rails's jquery-ujs driver.
					jQuery("*[data-spinner]")
							.live('ajax:beforeSend', function(e) {
								$(this).toggle();
								$($(this).data('spinner')).show();
								e.stopPropagation(); // Don't show spinner of parent elements.
							})
							.live("ajax:success", function(xhr, data, status) {
								$($(this).data('spinner')).hide();
								console.log('success');
								return false;
							})
							.live("ajax:complete", function(xhr, status) {
								$($(this).data('spinner')).hide();
								console.log('complete');
								return false;
							})
							.live(
									"ajax:error",
									function(xhr, status, error) {
										console.log('error ' + error
												+ "status=" + status);
										var errorStr = "An error occurred when the attemping an ajax request. [status :"
												+ xhr.status
												+ ",   Status Text :"
												+ xhr.status
												+ ",   Exception :"
												+ error
												+ "]";
										console.log('Error ' + errorStr);
										$($(this).data('spinner')).hide();

									});
				});



function removeAt(selector_to_remove) {
	console.log('remove selector :' + selector_to_remove);
	$(selector_to_remove).remove();
	console.log('removed selector :' + selector_to_remove);
}

function insertAt(location, content_to_insert) {
	console.log('inserting content :' + location + ' =>' + content_to_insert);
	$(location).html(content_to_insert);
	console.log('inserted  content :' + location + ' =>' + content_to_insert);
}
