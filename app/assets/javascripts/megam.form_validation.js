$(document).ready(function() {
	$("#change_profilename").click(function() {
		$('#first_name').prop('readonly', false);
	});

	$('#change_phonenumber').click(function(e) {
		$('#phonenumber').prop('readonly', false);
	});

	$("#change_password").click(function() {
		$('#newpassword').prop('readonly', false);
		$('#newpassword_confirmation').prop('readonly', false);
	});
});

function change_phone() {
	$('#phonenumber').prop('readonly', false);
}

function change_name() {
	$('#first_name').prop('readonly', false);
}

function change_current_password() {
	$('#newpassword').prop('readonly', false);
	$('#newpassword_confirmation').prop('readonly', false);
}


$(document).ready(function() {
	$("#megamform").validate({
		rules : {
			check_req : {
				required : true
			},
			email : {
				required : true,
				email : true
			}
		},
		messages : {
			check_req : "Just check the box"
		},
		tooltip_options : {
			check_req : {
				placement : 'right',
				html : true
			}
		}
	});

});

//Notification alert
$(document).ready(function() {
	//var count = $("#events ul").children().length;
	var count = $("#events li").length;

	if (count > 0) {
		$('#notification').removeClass('badge badge-success').addClass('badge badge-alert');
	}

});

// Remove alert message on clicking the close button
$(".c_remove").click(function() {
	$('.c_remove_main').hide();
});
