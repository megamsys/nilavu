$(document).ready(function() {
	var boo = false;
	var boo1 = false;
	$("#s3-uploader").S3Uploader();
	$("#new_db1 input:radio").click(function() {
		boo = true;
		if (boo1) {
			$("#db_next").attr("disabled", false); // enable next button
		}
	});
	$("#new_db2 input:radio").click(function() {
		boo1 = true;
		if (boo) {
			$("#db_next").attr("disabled", false); // enable next button
		}
	});	
	
	/*$("#upload").click(function() {
	    $('#fileupload').fileupload({
	        dataType: 'json',
	        done: function (e, data) {
	            $.each(data.result.files, function (index, file) {
	                $('<p/>').text(file.name).appendTo(document.body);
	            });
	        },
	    progressall: function (e, data) {
	        var progress = parseInt(data.loaded / data.total * 100, 10);
	        $('#progress .bar').css(
	            'width',
	            progress + '%'
	        );
	    }
	    });
	});*/
	
	 $("#cross_cloud_name").val("aws");	
	$("#cross_cloud_list").change(function() {
		var cc = $(this).find("option:selected").text()
		switch (cc) {
		case "Amazon EC2":			
			$("<div class='offset2' id='cloud_logo'><img src='/assets/logo_aws.png' height='100' width='100'/></div>").replaceAll('#cloud_logo');
			$("#cross_cloud_name").val("aws");	
			$("#cc_name").show();
			$("#cc_group").show();
			$("#cc_image").show();
			$("#cc_flavor").show();
			$("#cc_sshkey").show();
			$("#cc_sshuser").show();
			$("#cc_awspk").show();
			$("#cc_rsapk").show();
			$("#cc_awsak").show();
			$("#cc_awssk").show();
			break;
		case "hp cloud":		
			$("<div class='offset2' id='cloud_logo'><img src='/assets/logo_hp.png' height='100' width='100'/></div>").replaceAll('#cloud_logo');
			$("#cross_cloud_name").val("hp");	
			$("#cc_name").show();
			$("#cc_group").show();
			$("#cc_image").show();
			$("#cc_flavor").show();
			$("#cc_sshkey").show();
			$("#cc_sshuser").show();
			$("#cc_awspk").show();
			$("#cc_rsapk").show();
			$("#cc_awsak").show();
			$("#cc_awssk").show();
			break;
		case "Google cloud Engine":			
			$('#google_auth').prop("disabled",false);			
			$("<div class='offset2' id='cloud_logo'>" +
			   "<a href='/auth/google_oauth2'  target='_self'><img src='/assets/signin_google.png' /></a></br>" +
					"<img src='/assets/logo_gce.png' height='100' width='100'/>" +
					"</div>").replaceAll('#cloud_logo');
			$("#cross_cloud_name").val("google");		
			$("#cc_name").show();
			$("#cc_group").toggle();
			$("#cc_image").show();
			$("#cc_flavor").show();
			$("#cc_sshkey").toggle();
			$("#cc_sshuser").show();
			$("#cc_awspk").toggle();
			$("#cc_rsapk").show();
			$("#cc_awsak").toggle();
			$("#cc_awssk").toggle();
			break;
		default:			
			$("<div class='offset2' id='cloud_logo'><img src='/assets/logo_aws.png' height='100' width='100'/></div>").replaceAll('#cloud_logo');
		    $("#cross_cloud_name").val("aws");
		    $("#cc_name").show();
			$("#cc_group").show();
			$("#cc_image").show();
			$("#cc_flavor").show();
			$("#cc_sshkey").show();
			$("#cc_sshuser").show();
			$("#cc_awspk").show();
			$("#cc_rsapk").show();
			$("#cc_awsak").show();
			$("#cc_awssk").show();
		    break;
		}
		
	});
	

});


