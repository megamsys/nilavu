$(document).ready(function() {
	$('#book_rails').click(function() {		
	    var status = $(this).attr('id');	      
	    $('.btn ').attr('disabled', true);
	    $(this).attr('disabled', false);	   
	    $(this).text('Rails');
	});
});