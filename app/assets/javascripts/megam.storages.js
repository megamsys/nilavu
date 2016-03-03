$(document).ready(function() {
	$('.create_bucket_modal').click(function(e) {
		$('#create_bucket').modal();
	});
	$('.inner-menu').click(function(e) {
		e.preventDefault();
		$('.inner-child').toggle();
	});
	//storage left menu
	$('.toponeclick_left_add_inner').hide();


	// storage overview pop up menu
	$('.my_bucket_inner').bind('contextmenu', function(e) {
		e.preventDefault();
		$('.storage-popup').css({
			'top' : e.pageY,
			'left' : e.pageX
		});
		$('#bucketName').val($(event.currentTarget).attr('id'));
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

		//set timeout
		//timeout: 150000000,

		//maxChunkSize: 10000000000,

		// This element will accept file drag/drop uploading
		dropZone : $('#drop'),

		// This function is called when a file is added to the queue;
		// either via the browse button, or via drag/drop:
		add : function(e, data) {

			//var tpl = $('<li class="working"><input type="text" value="0" data-width="48" data-height="48"' + ' data-fgColor="#0788a5" data-readOnly="1" data-bgColor="#3e4043" /><p></p><div id="spin"></div><span></span></li>');

			var tpl = $('<tr class="working"><td class="td-left"><i id="format_icons" class="pop_icon"></i><b></b><i id="filesize"></i></td><td class="td-left pull-right m_icons"><i class="close_red"></i></td><td class="td-left pull-right"><i id="spin"></i></td></tr>');

			// Append the file name and file size
			tpl.find('b').text(data.files[0].name);
			var nameSplit = data.files[0].name.split('.');
			tpl.find("#format_icons").addClass(formatFileIcons(nameSplit[nameSplit.length - 1]));

			tpl.find('#filesize').text(' - ' + formatFileSize(data.files[0].size));

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
			$("#modal").remove();
			$('.modal-backdrop').remove();
		},

		fail : function(e, data) {
			// Something has gone wrong!
			data.context.addClass('error');
			data.context.find("#spin").hide();
		}
	});

	/*$('.objectPageList .objectListTd').load('.objectListTd', function() {
		var $this = $(this);
		var nameSplit = $this.attr('id').split('.');
		$this.find('#objectFormat').addClass(formatFileIcons(nameSplit[nameSplit.length - 1]));
	});


	//set objects page format icons
	function setObjectListFormat(name) {
		var nameSplit = name.split('.');
		$("#objectFormat_" + name).addClass(formatFileIcons(nameSplit[nameSplit.length - 1]));
	}*/

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

	function formatFileIcons(name) {
		if (name == '7z' || name == 'cbz' || name == 'cpio' || name == 'exe' || name == 'war' || name == 'iso' || name == 'ar' || name == 'tar.gz' || name == 'tar.Z' || name == 'tar.bz2' || name == 'tar.7z' || name == 'tar.lz' || name == 'tar.xz' || name == 'tar' || name == 'zip' || name == 'tgz' || name == 'rar' || name == 'jar' || name == 'gzip' || name == 'gz' || name == 'bz2') {
			return 'c_icon-zip'
		} else if (name == 'csv' || name == 'doc' || name == 'docx' || name == 'eml' || name == 'eps' || name == 'html' || name == 'html4' || name == 'html5' || name == 'key' || name == 'odp' || name == 'ods' || name == 'odt' || name == 'pdf' || name == 'ppt' || name == 'pst' || name == 'txt' || name == 'xml' || name == 'xps') {
			return 'c_icon-text'
		} else if (name == 'arw' || name == 'bmp' || name == 'cdr' || name == 'cr2' || name == 'crw' || name == 'dng' || name == 'erf' || name == 'gif' || name == 'ico' || name == 'jpg' || name == 'mdi' || name == 'mef' || name == 'mrw' || name == 'nef' || name == 'odg' || name == 'orf' || name == 'pcx' || name == 'pef' || name == 'ppm' || name == 'psd' || name == 'raf' || name == 'raw' || name == 'sr2' || name == 'tga' || name == 'thumbnail' || name == 'tiff' || name == 'wbmp' || name == 'webp' || name == 'wmf' || name == 'x3f' || name == 'xcf') {
			return 'c_icon-jpg'
		} else if (name == 'png') {
			return 'c_icon-png'
		} else if (name == 'svg') {
			return 'c_icon-svg'
		} else {
			return 'c_icon-text'
		}
	}

});
