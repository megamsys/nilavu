/**
 * Unicorn Admin Template Diablo9983 -> diablo9983@gmail.com
 */
$(document).ready(function() {

	/***************************************************************************
	 * *The below code is commented to allow the checkbox.css take over. This
	 * has a contention with checkbox.css. checkbox.css is used to select cloud
	 * apps(airplane mode)
	 * $('input[type=checkbox],input[type=radio],input[type=file]').uniform();
	 * 
	 * $('#multiple_selects').select2({ allowClear : true });
	 **************************************************************************/

	// Form Validation
	var validator = $(".megam_validate").validate({
		rules : {
			"name" : {
				required : true
			},
			"group" : {
				required : true
			},
			"image" : {
				required : true
			},
			"flavor" : {
				required : true
			},
			"region" : {
				required : true
			},
			"aws_access_key" : {
				required : true
			},
			"aws_secret_key" : {
				required : true
			},
			"hp_access_key" : {
				required : true
			},
			"hp_secret_key" : {
				required : true
			},
			"private_key" : {
				required : true
			},
			"id_rsa_public_key" : {
				required : true
			},
			"zone" : {
				required : true
			},
			"google_secret_key" : {
				required : true
			},
			"google_client_id" : {
				required : true
			},
			"project_name" : {
				required : true
			},
			"tenant_id" : {
				required : true
			},
			"ssh_user" : {
				required : true
			},
			"ssh_key" : {
				required : true
			}
		},
		errorClass : "help-inline",
		errorElement : "span",
		highlight : function(element, errorClass, validClass) {
			$(element).parents('.control-group').removeClass('success');
			$(element).parents('.control-group').addClass('error');

		},
		unhighlight : function(element, errorClass, validClass) {
			$(element).parents('.control-group').removeClass('error');
			$(element).parents('.control-group').addClass('success');

		},
		submitHandler : function(form) {
			showLoadingScreen();
			$.rails.handleRemote($(form)).always(function() {
				hideLoadingScreen()
			});
		}
	});

});
