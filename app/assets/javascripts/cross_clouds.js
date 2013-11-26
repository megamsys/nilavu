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
	
	$("#cross_cloud_list").change(function() {
		var cc = $(this).find("option:selected").text()
		switch (cc) {
		case "Amazon EC2":
			// alert($(this).find("option:selected").text())
			 // $("<%= image_tag('logo_aws.png', :size => '120x60', :id =>
				// 'cloud_logo') %>").replaceAll("#cloud_logo");
			// $('#cloud_logo').attr({src: "logo_aws.png"});
			$("<div class='offset2' id='cloud_logo'><img src='/assets/logo_aws.png' height='100' width='100'/></div>").replaceAll('#cloud_logo');
			break;
		case "hp cloud":
		// alert($(this).find("option:selected").text())
			// $("<%= image_tag('logo_hp.png', :size => '120x60', :id =>
			// 'cloud_logo') %>").replaceAll("#cloud_logo");
			// $('#cloud_logo').attr({src: "logo_hp.png"});
			$("<div class='offset2' id='cloud_logo'><img src='/assets/logo_hp.png' height='100' width='100'/></div>").replaceAll('#cloud_logo');
			break;
		case "Google cloud Engine":
			// alert($(this).find("option:selected").text())
			$('#google_auth').prop("disabled",false);
			// $("<%= image_tag('logo_gce.png', :size => '120x60', :id =>
			// 'cloud_logo') %>").replaceAll("#cloud_logo");
			// $('#cloud_logo').attr({src: "logo_gce.png"});
			$("<div class='offset2' id='cloud_logo'>" +
			   "<a href='/auth/google_oauth2'  target='_self'><img src='/assets/signin_google.png' /></a></br>" +
					"<img src='/assets/logo_gce.png' height='100' width='100'/>" +
					"</div>").replaceAll('#cloud_logo');
			break;
		default:
			// $('#cloud_logo').attr({src: "logo_aws.png"});
			$("<div class='offset2' id='cloud_logo'><img src='/assets/logo_aws.png' height='100' width='100'/></div>").replaceAll('#cloud_logo');
		}
		// alert($(this).find("option:selected").text()+' clicked!');
	});

});


