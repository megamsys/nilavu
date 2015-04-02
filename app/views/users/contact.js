
var selected_entity = '#contact_mail_success';
$(selected_entity).modal('show');
$("#reset").show();
$("#contact_modal").append('<%= link_to "Ok", root_path, :class => "btn btn-primary" %>');