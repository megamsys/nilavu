# Load the rails application
require File.expand_path('../application', __FILE__)
# Initialize the rails application
Nilavu::Application.initialize!

ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true

if Ind.notification.use == "smtp"
	ActionMailer::Base.delivery_method = :smtp
	ActionMailer::Base.smtp_settings = {
		:enable_starttls_auto => true,
		:address        => Ind.notification.smtp.address,
		:port           => Ind.notification.smtp.port,
		:domain         => Ind.notification.smtp.domain,
		:user_name      => Ind.notification.smtp.email,
		:password       => Ind.notification.smtp.password,
		:authentication => :plain
	}
end

if Ind.notification.use == "mailgun"
	ActionMailer::Base.delivery_method = :mailgun
	ActionMailer::Base.mailgun_settings = { api_key: Ind.notification.mailgun.api_key,
		domain: Ind.notification.mailgun.domain }
end

#ActionMailer::Base.default_url_options[:host] = "http://localhost:3000"
