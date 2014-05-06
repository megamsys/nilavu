//everything is just for the disaster recovery service. Doesn't make sense to have it in here.
jQuery(document).ready(function() {
	$("#backup_storage_view").hide();
	$('#drbd_next').prop('disabled', true);

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

jQuery(document).ready(
		function() {
			// used by drbd
			var CHOOSE_DEFAULT = "Choose an App/Service"
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
									CHOOSE_DEFAULT).trigger("change");
							
							$('#drbdhost_selection_error').modal({
								backdrop : false,
								keyboard : false,
								show : true
							});
						}
						check_submit($('#fromhost select').select2('val'),$('#tohosts select').select2('val'));
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
						check_submit($('#fromhost select').select2('val'),$('#tohosts select').select2('val'));
						return allowed;

					});
					
				
				$('#locations').bind('hastext', function () {
					//flag = true;
					alert("LOCATION HAS TEXT");
				  });
				  
			$("#backuphost select").click(
					function() {
						var addon_nodename = "";
						var allowed = true;

						$("#backuphost option:selected").each(function() {
							addon_nodename = $(this).text();
							$('#addon_nodename').val(addon_nodename);
						});
						check_backup($('#backuphost select').select2('val'));
						return allowed;
					});
					
					
			
			function check_submit(fromHostVal, toHostVal) {
				  if (fromHostVal.length == 0 || toHostVal.length ==0 || fromHostVal == CHOOSE_DEFAULT || toHostVal == CHOOSE_DEFAULT) {
				    $("#drbd_next").attr("disabled", true);
				  } else {
				    $("#drbd_next").removeAttr("disabled");
				  }
				}
			function check_backup(backuphostVal) {
				  var flag = false;
				  $('#locations').bind('hastext', function () {
					flag = true;
				  });
				  alert("Allowed"+flag);
				  if (backuphostVal.length == 0 ||  backuphostVal == CHOOSE_DEFAULT || !allowed) {
				    $("#drbd_next").attr("disabled", true);
				  } else {
				    $("#drbd_next").removeAttr("disabled");
				  }
				}
		});

