(function( $ ){	
	$.fn.scale_aggregate = function() {
		var books_count = 0;
		var selected_platformapp ="";
		this.find('tbody').find('tr').each(function() {
			books_count = parseInt($(this).find('span.books.count').text());
		});
		this.find('tbody').find('tr').each(function() {
			selected_platformapp = $(this).attr('class');
		});

		$('.books_total').text(books_count).fadeIn('slow');
		$('.selected_platformapp').fadeIn('slow').text(selected_platformapp);
		

	};	
	
})( jQuery );

$(document).ready(function() {	
	$('#platformfaulty input:radio').each(function() {
		var self = $(this), label = self.next(), label_text = label.text();
		label.remove();
		self.iCheck({
			checkboxClass : 'icheckbox_flat',
			radioClass : 'iradio_flat',
			insert : '<div class="icheck_line-icon"></div>' + label_text
		});
	});	
	$('#next').click(function(){
		$('#domainname').val($('#identity_new_account_name').text() + $('#domain').text());	
	$(".check-radio").each(function(){ 
        if( $(this).is(":checked") ){ 
        	$('#predefcloudname').val('ec2_' + $(this).val());
            var val = $(this).val(); 
        }
    });
	});	
	
	
});



$(document).ready(function(){		
	// find the scaling instance counter table element
	var scale_counter = $('#scalebooks');
	
	//set the initial value of $0.00
	scale_counter.scale_aggregate();
	var $minus = '<a href="#" class="minus"><i class="icon-minus"></i></a>';
	var $plus = '<a href="#" class="plus"><i class="icon-plus"></i></a>';
	var $trash = '<td> <a href="#" class="trash"><i class="icon-trash"></i></a></td>'

	$("#platformapps input:radio").click(function() {
		var service = $(this).attr("value");	
		scale_counter.find('tr').remove();
		$('#scalebooks').scale_aggregate();
		scale_counter.find('tbody').append('<tr class="'+ service + '"> </tr>');
		row = $('tr.' + service);
		row.append('<td><div class="overlay"><i class="icon-trash"></i></div><i class="logo_' + service  + '"></i></div></th>')
		.append('<td class="instances">'+ $minus + '<span class="books count">1</span>'+ $plus + '</td>')				
		.append($trash);
		$('#scalebooks').scale_aggregate();
		// _gaq is a global goole analytic object. We can track what the user choose.
		// https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApi_gaq
		//_gaq.push(['_trackEvent', 'Calculator', 'Service', service]);	
	});
	
	
	//add the functionality to the +/- buttons
	scale_counter.delegate('.instances a.plus', 'click', function(){ 
		var instance = parseInt($(this).parents('tr').find('.books.count').text());
		if (instance < 2) { 
			instance = instance +1;
			$(this).parent().find('.books').text(instance);
			scale_counter.scale_aggregate();
		}
		return false;
	}).delegate('.instances a.minus', 'click', function(){ 
		var value = parseInt($(this).parent().find('.books').text());
		//set a min value
		if ( value > 1) {
			value = value - 1;
			$(this).parent().find('.books').text(value);
			scale_counter.scale_aggregate();
		}
		return false;
	}).delegate('a.trash', 'click', function(){
		var logo = $(this).parents('tr').attr('class');
		$(this).parents('tr').remove(); 
		scale_counter.scale_aggregate();
		return false;
	});
});

$(function(){
	// bind a callback to the step_shown event
	$("#form-wizard").bind("step_shown", function(event, data){
		var a = $("#platformapps input:radio:checked").attr("value");

    $("#wiz_data").text(a);
    //$("#wiz_data").html("<h1> THOMAS </h1>");
    //$("#wiz_data").html("<%= a %>");
	});
});


$(function(){		
				$("#form-wizard").formwizard({ 
				 	formPluginEnabled: true,
				 	validationEnabled: true,
				 	focusFirstInput : true,
				 	formOptions :{

						beforeSubmit: function(data){$("#data").html("data sent to the server: " + $.param(data));},
						dataType: 'json',
						resetForm: true
				 	}
				 }
				);
			
			var remoteAjax = {}; // empty options object

			$("#form-wizard .step").each(function(){ // for each step in the wizard, add an option to the remoteAjax object...
				remoteAjax[$(this).attr("id")] = {

					beforeSubmit: function(data){$("#data").html("data sent to the server: " + $.param(data))},

					};
			});

			$("#form-wizard").formwizard("option", "remoteAjax", remoteAjax); // set the remoteAjax option for the wizard
  		});


