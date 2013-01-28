jQuery(document)
		.ready(
				function() {

					// "ajax:beforeSend" and "ajax:complete" event hooks are
					// provided by Rails's jquery-ujs driver.
					// ajax:complete => after the request has been completed, no
					// matter what outcome
					jQuery("*[data-spinner]")
							.on('ajax:beforeSend', function(e) {
								/*
								 * Whoever has data-spinner will get toggled. On
								 * success/error. This is retoggled back.
								 */
								$(this).toggle();
								$($(this).data('spinner')).show();
								console.log('started - before stop props');
								e.stopPropagation(); // Don't show spinner of
								console.log('started - after stop props');
								// parent elements.
							})
							.on("ajax:success", function(xhr, data, status) {
								console.log('success');
								return false;
							})
							.on("ajax:complete", function(xhr, status) {
								$($(this).data('spinner')).hide();
								console.log('complete');
								return false;
							})
							.on(
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
										return false;

									});

					// "ajax:beforeSend" and "ajax:complete" event hooks are
					// provided by Rails's jquery-ujs driver.
					jQuery("*[data-spinlock]")
							.on('ajax:beforeSend', function(e) {
								$(this).spin("large", "Black");
								$('#loading').fadeIn();
								console.log('lock spin started');
								e.stopPropagation(); // Don't show spinner of
								// parent elements.
							})
							.on("ajax:success", function(xhr, data, status) {
								console.log('lock spin success');
								return false;
							})
							.on("ajax:complete", function(xhr, status) {
								$(this).spin(false); // Kills the spinner.
								$('#loading').fadeOut();
								console.log('lock spin complete');
								return false;
							})
							.on(
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
										console.log('Error ' + errorStr + "\n"
												+ xhr.reponseText);
										return false;
									});

				});

function removeAt(selector_to_remove) {
	$(selector_to_remove).remove();
	console.log('removed selector :' + selector_to_remove);
}

function insertAt(location, content_to_insert) {
	$(location).html(content_to_insert);
	console.log('inserted  content :' + location + ' =>' + content_to_insert);
}

function repWith(location, content_to_replace) {
	$(location).replaceWith(content_to_replace);
	console.log('replaced  content :' + location + ' =>' + content_to_replace);
}