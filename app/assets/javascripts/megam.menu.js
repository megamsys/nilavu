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

});
