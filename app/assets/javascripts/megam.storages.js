$(document).ready(function() {
	$('.create_bucket_modal').click(function(e) {
		$('#create_bucket').modal();
	});
	$('.inner-menu').click(function(e) {
		e.preventDefault();
		$('.inner-child').toggle();
	});
	//storage left menu
	$('.storage_left_add_inner').hide();
	$('.storage_left_add a ').click(function() {
		// e.preventDefault();
		$('.storage_left_add_inner').slideToggle();
	});
	// $('.storage-popup').hide();
	// storage overview pop up menu
	$('.my_bucket_inner').bind('contextmenu', function(e) {
		e.preventDefault();
		$('.storage-popup').css({
			'top' : e.pageY,
			'left' : e.pageX
		});
		$('#bucketName').val($(event.currentTarget).attr('id'));
		//$.session.set('bucketname', $(event.currentTarget).attr('id'));
		$('.storage-popup').show();
		return false;
	});
	// hide storage menu when clicked outside the div
	$(document).on('click', function(e) {
		if ($(e.target).closest(".my_bucket_inner").length === 0) {
			$('.storage-popup').hide();
		}
	});

   //jquery file upload with loader.gif
    $('#gupload #objectfile').hide();
	var ul = $('.tr_upload_list');
	$('#brow').click(function() {
		// Simulate a click on the file input button
		// to show the file browser dialog
		//$(this).parent().find('input').click();
		$('#objectfile').trigger('click');
	});

	// Initialize the jQuery FilebUpload plugin
	$('#gupload').fileupload({

		// This element will accept file drag/drop uploading
		dropZone : $('#drop'),

		// This function is called when a file is added to the queue;
		// either via the browse button, or via drag/drop:
		add : function(e, data) {

			//var tpl = $('<li class="working"><input type="text" value="0" data-width="48" data-height="48"' + ' data-fgColor="#0788a5" data-readOnly="1" data-bgColor="#3e4043" /><p></p><div id="spin"></div><span></span></li>');
            
            var tpl = $('<tr class="working"><td class="td-left"><i class="pop_icon c_icon-png"></i><b></b><i id="filesize"></i></td><td class="td-left pull-right m_icons"><i class="close_red"></i></td><td class="td-left pull-right"><i id="spin"></i></td></tr>');
			
			// Append the file name and file size
			tpl.find('b').text(data.files[0].name)
			tpl.find('#filesize').text(' - '+formatFileSize(data.files[0].size));

			// Add the HTML to the UL element
			data.context = tpl.appendTo(ul);			

			tpl.find('#spin').html('<img src="assets/loader.gif" alt="Wait" />');

			// Listen for clicks on the cancel icon
			tpl.find('.m_icons').click(function() {

				if (tpl.hasClass('working')) {
					jqXHR.abort();
				}

				tpl.fadeOut(function() {
					tpl.remove();
				});

			});

			// Automatically upload the file once it is added to the queue
			var jqXHR = data.submit();
		},

		progress : function(e, data) {

			// Calculate the completion percentage of the upload
			var progress = parseInt(data.loaded / data.total * 100, 10);

			// Update the hidden input field and trigger a change
			// so that the jQuery knob plugin knows to update the dial
			data.context.find('input').val(progress).change();

			if (progress == 100) {
				data.context.removeClass('working');
			}
		},

		done : function(e, data) {
			data.context.removeClass('working');
			data.context.find('.m_icons i').removeClass('close_red');
			data.context.find('.m_icons i').addClass('c_ico-tick');
			data.context.find("#spin").hide();

		},

		fail : function(e, data) {
			// Something has gone wrong!
			data.context.addClass('error');
			data.context.find("#spin").hide();
		}
	});	

	// Helper function that formats the file sizes
	function formatFileSize(bytes) {
		if ( typeof bytes !== 'number') {
			return '';
		}

		if (bytes >= 1000000000) {
			return (bytes / 1000000000).toFixed(2) + ' GB';
		}

		if (bytes >= 1000000) {
			return (bytes / 1000000).toFixed(2) + ' MB';
		}

		return (bytes / 1000).toFixed(2) + ' KB';
	};
	

});
