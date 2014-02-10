jQuery(document)
		.ready(
				function() {					
									
									$("#ssh_keys_page input:radio").on( "click", function() {
										var key_name = $(this).attr("name");
										if (key_name == "new_key") {											
											$("#new_ssh_keys *").attr("disabled", "").off('click');
											$("#upload_ssh_keys *").attr("disabled", "disabled").off('click');
										}
										else {
											$("#new_ssh_keys *").attr("disabled", "disabled").off('click');
											$("#upload_ssh_keys *").attr("disabled", "").off('click');
										}						
										
																	
									});
				});