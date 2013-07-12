$('#validate').validate({
	 debug: true,
    rules: {
        first_name: "required",
        last_name: "required",
        phone: "required",
        email: {
            required: true,
            email: true
        }
    },
    messages: {
        first_name: "Please specify your first name",
        last_name: "Please specify your last name",
        phone: "Please specify your phone number",
        email: {
            required: "We need your email address to contact you",
            email: "Your email address must be in the format of name@domain.com"
        }
    }
});
