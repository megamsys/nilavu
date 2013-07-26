$(document).ready(function() {
	
	$('.check-radio').each(function() {
		var self = $(this), label = self.next(), label_text = label.text();
		label.remove();
		self.iCheck({
			checkboxClass : 'icheckbox_line-green',
			radioClass : 'iradio_line-green',
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

	$('#book_to_run').click(function(){
		
	})
});