$(document).ready(function() {
	var boo = false;
	var boo1 = false;
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
			break;
		case "hp cloud":		
			$("<div class='offset2' id='cloud_logo'><img src='/assets/logo_hp.png' height='100' width='100'/></div>").replaceAll('#cloud_logo');
			$("#cross_cloud_name").val("hp");						
			break;
		case "Google cloud Engine":			
			$('#google_auth').prop("disabled",false);			
			$("<div class='offset2' id='cloud_logo'>" +
			   "<a href='/auth/google_oauth2'  target='_self'><img src='/assets/signin_google.png' /></a></br>" +
					"<img src='/assets/logo_gce.png' height='100' width='100'/>" +
					"</div>").replaceAll('#cloud_logo');
			$("#cross_cloud_name").val("google");			;
			break;
		default:			
			$("<div class='offset2' id='cloud_logo'><img src='/assets/logo_aws.png' height='100' width='100'/></div>").replaceAll('#cloud_logo');
		    $("#cross_cloud_name").val("aws");		    
		    break;
		}
		
	});
	

});


