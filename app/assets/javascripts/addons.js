jQuery(document).ready(
		function() {

			// used by drbd
			$("#fromhost select").click(
					function() {
						var addon_nodename = "";
						var allowed = true;

						$("#fromhost option:selected").each(function() {
							addon_nodename = $(this).text();
							$("#tohosts option:selected").each(function() {
								if (addon_nodename == $(this).text()) {
									allowed = false;
								}
							});

						});
						if (allowed) {
							$('#addon_nodename').val(addon_nodename);
						} else {
							$('#fromhost select[name=fromhost]').val(
									'Choose an App/Service').trigger("change");
							
							$('#drbdhost_selection_error').modal({
								backdrop : false,
								keyboard : false,
								show : true
							});
						}
						return allowed;

					});
			
			// used by drbd
			$("#tohosts select").click(
					function() {
						var addon_nodename = "";
						var allowed = true;

						$("#tohosts option:selected").each(function() {
							addon_nodename = $(this).text();
							$("#fromhost option:selected").each(function() {
								if (addon_nodename == $(this).text()) {
									allowed = false;
								}
							});
							if(!allowed) {
								 $("#tohosts select").select2("val",  "");
							}

						});
						if (!allowed) {							
							
							$('#drbdhost_selection_error').modal({
								backdrop : false,
								keyboard : false,
								show : true
							});
						}
						return allowed;

					});
		});
