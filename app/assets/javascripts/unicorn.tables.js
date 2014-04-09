/**
 * Unicorn Admin Template Version 2.1.0 Diablo9983 -> diablo9983@gmail.com
 */

$(document).ready(
		function() {
			
		    $('.spinner').spinner();		


			$('.datatable').dataTable({
				"sPaginationType" : "bootstrap"
			});

			var checkboxClass = 'icheckbox_flat-blue';
			var radioClass = 'iradio_flat-blue';

			$('select').select2({
				width: "element",
				allowClear: true,
				placeholder: "Choose .."
			});

			$("span.icon input:checkbox, th input:checkbox").on(
					'ifChecked || ifUnchecked',
					function() {
						var checkedStatus = this.checked;
						var checkbox = $(this).parents('.widget-box').find(
								'tr td:first-child input:checkbox');
						checkbox.each(function() {
							this.checked = checkedStatus;
							if (checkedStatus == this.checked) {
								$(this).closest('.' + checkboxClass)
										.removeClass('checked');
							}
							if (this.checked) {
								$(this).closest('.' + checkboxClass).addClass(
										'checked');
							}
						});
					});
		});
