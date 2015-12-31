$(document).ready(function() {

	$('.app_config').click(function(event) {
		$('.config_menu').hide();
		$('.app_config').removeClass('config_acive');
		cls = this.id;
		event.stopPropagation();
		$('.' + cls).toggle();
		$(this).toggleClass('config_acive');
	});
	$(document).click(function() {
		$('.config_menu').hide();
		$('.app_config').removeClass('config_acive');
	});

	$('#app-list-view').hide();

	$('#app-btn-list').click(function() {
		$('#app-grid-view').hide();
		$('#app-list-view').show();
	});

	$('#app-btn-grid').click(function() {
		$('#app-grid-view').show();
		$('#app-list-view').hide();
	});

	$(window).on('resize', function() {
		if ($(window).width() < 480) {
			$('#app-list').hide();
			$('#app-grid').show();
		};
	});

	$('#marketplace_top_right').hover(function() {
		$('#marketplace_top_right i').toggleClass('c_icon-window-lg');
		$('#marketplace_top_right i').toggleClass('c_icon-window-lg-sel');
		$('#marketplace_top_right span').toggleClass('mplace-selected');
	});
	$('#storage_top_right').hover(function() {
		$('#storage_top_right i').toggleClass('c_icon-storage-lg');
		$('#storage_top_right i').toggleClass('c_icon-storage-lg-sel');
		// $('#stor i').toggleClass('c_icon-grid');
		$('#storage_top_right span').toggleClass('mplace-selected');
	});

});
