$(document).ready(function() {

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
		$('#storage_top_right i').toggleClass('c_icon-grid-hover');
		$('#storage_top_right i').toggleClass('c_icon-grid-25');
		// $('#stor i').toggleClass('c_icon-grid');
		$('#storage_top_right span').toggleClass('mplace-selected');
	});

});
