$(document).ready(function() {
	$('#book_rails').click(function() {
		var status = $(this).attr('id');
		$('.btn ').attr('disabled', true);
		$(this).attr('disabled', false);
		$(this).text('Rails');
	});
	$('.check-radio').each(function() {
		var self = $(this), label = self.next(), label_text = label.text();
		label.remove();
		self.iCheck({
			checkboxClass : 'icheckbox_line-green',
			radioClass : 'iradio_line-green',
			insert : '<div class="icheck_line-icon"></div>' + label_text
		});
	});	
});