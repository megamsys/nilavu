(function($) {
	$.fn.scale_aggregate = function() {
		var books_count = 0;
		var selected_platformapp = "";
		this.find('tbody').find('tr').each(function() {
			books_count = parseInt($(this).find('span.books.count').text());
		});
		this.find('tbody').find('tr').each(function() {
			selected_platformapp = $(this).attr('class');
		});

		$('#books_total').text(books_count).fadeIn('slow');
		$('#cb_count').val(books_count);
		$('#selected_platformapp').fadeIn('slow').html(
				'<div id="selected_platformapp"><b>' + selected_platformapp
						+ '</b></div>');

	};

})(jQuery);

$(document).ready(function() {
	$("#repo_select").change(function() {
		var id = $(this).val();
		$('#selected_debs_scm').val(id);
		return false;

	});

});

jQuery(document)
		.ready(
				function() {

					var scale_counter = $('#scalebooks');

					// set the initial value of $0.00
					scale_counter.scale_aggregate();
					var $minus = '<a href="#" class="minus"><i class="fa fa-minus-square"></i></a>';
					var $plus = '<a href="#" class="plus"><i class="fa fa-plus-square"></i></a>';
					var $trash = '<td> <a href="#" class="trash"><i class="fa fa-trash-o"></i></a></td>';

					$("#platformapps input:radio")
							.on(
									"ifClicked",
									function() {
										$("#cb_next").attr("disabled", false); // enable
										$("#db_next").attr("disabled", false); // enable

										// next
										// button
										var service = $(this).attr("value");
										if ($("#scm_code input[type='radio']:checked").val() == "scm_sample") {
											$("#scm_sample").show();	
											choose_samples(service);
											$("#scm_tool").hide();
											$("#scm_sample_view").show();
											$("#scm_tool_view").hide();
										}
										scale_counter.find('tr').remove();
										$('#scalebooks').scale_aggregate();
										scale_counter.find('tbody').append(
												'<tr class="' + service
														+ '"> </tr>');
										row = $('tr.' + service);
										row
												.append(
														'<td><div class="overlay"><i class="fa fa-trash-o"></i></div><i class="logo_'
																+ service
																+ '"></i></div></th>')
												.append(
														'<td class="instances">'
																+ $minus
																+ '&nbsp;'
																+ '<span class="books count">1</span>&nbsp;'
																+ $plus
																+ '</td>')
												.append($trash);
										$('#scalebooks').scale_aggregate();
										// _gaq is a global goole analytic
										// object. We can track what the user
										// choose.
										// https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApi_gaq
										// _gaq.push(['_trackEvent',
										// 'Calculator', 'Service', service]);
									});

					// add the functionality to the +/- buttons
					scale_counter.delegate(
							'.instances a.plus',
							'click',
							function() {
								var instance = parseInt($(this).parents('tr')
										.find('.books.count').text());
								if (instance < 2) {
									instance = instance + 1;
									$(this).parent().find('.books').text(
											instance);
									scale_counter.scale_aggregate();
								}
								return false;
							})
							.delegate(
									'.instances a.minus',
									'click',
									function() {
										var value = parseInt($(this).parent()
												.find('.books').text());
										// set a min value
										if (value > 1) {
											value = value - 1;
											$(this).parent().find('.books')
													.text(value);
											scale_counter.scale_aggregate();
										}
										return false;
									}).delegate('a.trash', 'click', function() {
								var logo = $(this).parents('tr').attr('class');
								$(this).parents('tr').remove();
								scale_counter.scale_aggregate();
								return false;
							});

				});

jQuery(document)
		.ready(
				function() {
					$("#scm_sample").hide();
					$("#scm_sample_view").hide();
					$("#scm_code input:radio")
							.on(
									"ifClicked",
									function() {
										var service = $(this).attr("value");
										var selected_app_fwrk = $(
												"#platformapps input[type='radio']:checked")
												.val()
										if (selected_app_fwrk != null) {
											if (service == "scm_tool") {
												$("#scm_sample").hide();
												$("#scm_tool").show();
												$("#scm_sample_view").hide();
											}
											if (service == "scm_sample") {
												$("#scm_sample").show();	
												choose_samples(selected_app_fwrk);			
												$("#scm_tool").hide();
												$("#scm_sample_view").show();
												$("#scm_tool_view").hide();
											}
										} else {
											$("#choose_framework_error_popup")
													.modal({
														backdrop : false,
														keyboard : false,
														show : true
													});

										}
									});

				});

function choose_samples(selected_sample_framework) {

	
	if (selected_sample_framework == 'java') {
		java();
	}
	if (selected_sample_framework == 'play') {
		play();
	}
	if (selected_sample_framework == 'rails') {
		rails();
	}
	if (selected_sample_framework == 'akka') {
		akka();
	}
	if (selected_sample_framework == 'nodejs') {
		nodejs();
	}
	$("[id^=githubsample_]").click(function() {
		var selected_github = $(this).next().attr("href");
		$("#selected_debs_scm").val(selected_github);
		$("#selected_debs_scm").fadeIn("slow");
	});
	
}

function java() {
	$('#sample_repo')
			.fadeIn('slow')
			.html(
					'<div id="sample_repo"> <table class="table table-hover"> <tbody><tr><td><span class="badge badge-info">Java</span></td><td><i class="fa fa-plus-square git_javawar" id="githubsample_javawar"></i> This sample launches a java based online code editor called orion. The bundle that is used is available <a href="https://s3-ap-southeast-1.amazonaws.com/megampub/0.1/war/orion.war" target="_blank"> here. </a></td></tr><tr><td><span class="badge badge-info">Java</span></td><td><i class="fa fa-plus-square" id="githubsample_java"></i>This sample launches a spring based Java App.The source code that is used for the launch is available <a href="https://github.com/thomasalrin/spring-mvc-fulfillment-base.git" target="_blank"> here.</a></td></tr></tbody></table> </div>');
}

function play() {
	$('#sample_repo')
			.fadeIn('slow')
			.html(
					'<div id="sample_repo"> <table class="table table-hover"> <tbody><tr><td><span class="badge badge-info">Play</span></td><td><i class="fa fa-plus-square" id="githubsample_play"></i>This sample launches a play based scala App.The source code that is used for the launch is available <a href="https://github.com/thomasalrin/megam_play.git" target="_blank">here </a></td></tr></tbody></table> </div>');
}

function rails() {
	$('#sample_repo')
			.fadeIn('slow')
			.html(
					'<div id="sample_repo"> <table class="table table-hover"> <tbody><tr><td><span class="badge badge-info">Ruby</span></td><td><i class="fa fa-plus-square" id="githubsample_ror"></i>This sample launches a ruby on rails 4.0 twitter bootstrap based portal.The source code that is used for the launch is available <a href="https://github.com/thomasalrin/aryabhata.git" target="_blank"> here</a></td></tr></tbody></table> </div>');
}

function akka() {
	$('#sample_repo')
			.fadeIn('slow')
			.html(
					'<div id="sample_repo"> <table class="table table-hover"> <tbody><tr><td><span class="badge badge-info">Akka</span></td><td><i class="fa fa-plus-square" id="githubsample_akka"></i>This sample launches a akka daemon that spawns a cluster of masters which delegates work to its slave.The source code that is used for the launch is available<a href="https://github.com/thomasalrin/megam_akka.git" target="_blank">here</a></td></tr></tbody></table> </div>');
}
function nodejs() {
	$('#sample_repo')
			.fadeIn('slow')
			.html(
					'<div id="sample_repo"> <table class="table table-hover"> <tbody><tr><td><span class="badge badge-info">Nodejs</span></td><td><i class="fa fa-plus-square" id="githubsample_nodejs"></i>This sample launches ghost which is a free, open, simple blogging platform.The source code that is used for the launch is available <a href="https://github.com/thomasalrin/ghost.git" target="_blank"> here</a></td></tr></tbody></table> </div>');
}