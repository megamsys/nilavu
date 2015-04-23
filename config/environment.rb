# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Cloudauth::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address        => "smtp.googlemail.com",
  :port           => "587",
  :domain         => "megam.io",
  :user_name      => Rails.configuration.support_email,
  :password       => Rails.configuration.support_password,
  :authentication => :plain
}

#ActionMailer::Base.default_url_options[:host] = "https://www.megam.io"
ActionMailer::Base.default_url_options[:host] = "localhost:3000"
