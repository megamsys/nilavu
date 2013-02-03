/**
 * Unicorn Admin Template Diablo9983 -> diablo9983@gmail.com
 */
$(document).ready(function() {

	/*
	 **The below code is commented to allow the checkbox.css take over.
	 *This has a contention with checkbox.css. checkbox.css is used to select cloud apps(airplane mode)
	 *$('input[type=checkbox],input[type=radio],input[type=file]').uniform();

	$('#multiple_selects').select2({
		allowClear : true
	}); **/

	// Form Validation
	$("#basic_validate").validate({
		rules : {
		/***********************************************************************
		 * Don't fill any rules here. The rules are controlled by setting
		 * required in the class of the input text-field. Right now the
		 * validation is used by contactus form, and signup form.
		 **********************************************************************/
			
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
		}
	});

	$("#password_validate").validate({
		rules : {
			"session[password]" : {
				required : true,
				minlength : 6,
				maxlength : 20
			},
			"user[password]" : {
				required : true,
				minlength : 6,
				maxlength : 20
			},
			"user[password_confirmation]" : {
				required : true,
				minlength : 6,
				maxlength : 20,
				equalTo : "#user_password"
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
		}
	});
});
